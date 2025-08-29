from django.db import models
from users.models import UserProfile


class NotificationItem(models.Model):
    """Notification system for the VSLA platform"""
    
    TYPE_CHOICES = [
        ('screening_result', 'Screening Result'),
        ('reminder', 'Reminder'),
        ('achievement', 'Achievement'),
        ('message', 'Message'),
        ('appointment', 'Appointment'),
        ('follow_up', 'Follow Up'),
        ('health_tip', 'Health Tip'),
        ('system', 'System'),
        ('abnormal_result', 'Abnormal Result'),
        ('summary', 'Summary'),
    ]
    
    ACTION_CHOICES = [
        ('view_result', 'View Result'),
        ('view_appointment', 'View Appointment'),
        ('view_achievement', 'View Achievement'),
        ('open_chat', 'Open Chat'),
        ('view_tip', 'View Tip'),
        ('schedule_follow_up', 'Schedule Follow Up'),
        ('submit_report', 'Submit Report'),
        ('review_abnormal_result', 'Review Abnormal Result'),
        ('view_summary', 'View Summary'),
        ('schedule_maintenance', 'Schedule Maintenance'),
    ]
    
    user = models.ForeignKey(
        UserProfile, 
        on_delete=models.CASCADE, 
        related_name='notifications'
    )
    
    # Notification content
    title = models.CharField(max_length=200)
    message = models.TextField()
    type = models.CharField(max_length=30, choices=TYPE_CHOICES)
    
    # Action and related data
    action = models.CharField(max_length=30, choices=ACTION_CHOICES)
    related_id = models.CharField(max_length=100, blank=True, help_text="ID of related object")
    
    # Status and timing
    is_read = models.BooleanField(default=False)
    timestamp = models.DateTimeField(auto_now_add=True)
    scheduled_for = models.DateTimeField(null=True, blank=True, help_text="For scheduled notifications")
    
    # Additional metadata
    priority = models.CharField(
        max_length=10, 
        choices=[('low', 'Low'), ('medium', 'Medium'), ('high', 'High')],
        default='medium'
    )
    category = models.CharField(max_length=50, blank=True, help_text="Notification category for grouping")
    
    # Timestamps
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        verbose_name = 'Notification Item'
        verbose_name_plural = 'Notification Items'
        ordering = ['-timestamp', '-priority']
        indexes = [
            models.Index(fields=['user', 'is_read', 'timestamp']),
            models.Index(fields=['type', 'timestamp']),
            models.Index(fields=['scheduled_for', 'timestamp']),
        ]
    
    def __str__(self):
        return f"{self.user.get_full_name()} - {self.title} ({self.type})"
    
    def mark_as_read(self):
        """Mark notification as read"""
        self.is_read = True
        self.save(update_fields=['is_read'])
        # Update user's notification count
        self.user.notifications = max(0, self.user.notifications - 1)
        self.user.save(update_fields=['notifications'])
    
    def is_scheduled(self):
        """Check if notification is scheduled for future delivery"""
        return self.scheduled_for is not None and self.scheduled_for > self.timestamp
    
    def should_deliver(self):
        """Check if notification should be delivered now"""
        from django.utils import timezone
        if self.scheduled_for:
            return timezone.now() >= self.scheduled_for
        return True


class NotificationTemplate(models.Model):
    """Templates for common notification types"""
    
    name = models.CharField(max_length=100, unique=True)
    title_template = models.CharField(max_length=200)
    message_template = models.TextField()
    type = models.CharField(max_length=30, choices=NotificationItem.TYPE_CHOICES)
    action = models.CharField(max_length=30, choices=NotificationItem.ACTION_CHOICES)
    
    # Template variables
    variables = models.JSONField(
        default=list, 
        help_text="List of variables that can be used in the template"
    )
    
    # Usage tracking
    is_active = models.BooleanField(default=True)
    usage_count = models.PositiveIntegerField(default=0)
    
    # Timestamps
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        verbose_name = 'Notification Template'
        verbose_name_plural = 'Notification Templates'
        ordering = ['name']
    
    def __str__(self):
        return f"{self.name} ({self.type})"
    
    def increment_usage(self):
        """Increment usage counter"""
        self.usage_count += 1
        self.save(update_fields=['usage_count'])
    
    def render_notification(self, context_data):
        """Render notification using template and context data"""
        title = self.title_template
        message = self.message_template
        
        # Replace variables in templates
        for key, value in context_data.items():
            title = title.replace(f"{{{key}}}", str(value))
            message = message.replace(f"{{{key}}}", str(value))
        
        return {
            'title': title,
            'message': message,
            'type': self.type,
            'action': self.action
        }


class NotificationPreference(models.Model):
    """User notification preferences"""
    
    user = models.OneToOneField(
        UserProfile, 
        on_delete=models.CASCADE, 
        related_name='notification_preferences'
    )
    
    # General preferences
    email_notifications = models.BooleanField(default=True)
    push_notifications = models.BooleanField(default=True)
    sms_notifications = models.BooleanField(default=False)
    
    # Type-specific preferences
    screening_results = models.BooleanField(default=True)
    reminders = models.BooleanField(default=True)
    achievements = models.BooleanField(default=True)
    messages = models.BooleanField(default=True)
    health_tips = models.BooleanField(default=True)
    system_notifications = models.BooleanField(default=True)
    
    # Frequency preferences
    daily_digest = models.BooleanField(default=False)
    weekly_summary = models.BooleanField(default=True)
    
    # Quiet hours
    quiet_hours_start = models.TimeField(null=True, blank=True)
    quiet_hours_end = models.TimeField(null=True, blank=True)
    
    # Timestamps
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        verbose_name = 'Notification Preference'
        verbose_name_plural = 'Notification Preferences'
    
    def __str__(self):
        return f"{self.user.get_full_name()} - Notification Preferences"
    
    def is_quiet_hours(self):
        """Check if current time is within quiet hours"""
        from django.utils import timezone
        if not self.quiet_hours_start or not self.quiet_hours_end:
            return False
        
        now = timezone.now().time()
        start = self.quiet_hours_start
        end = self.quiet_hours_end
        
        if start <= end:
            return start <= now <= end
        else:  # Overnight quiet hours
            return now >= start or now <= end
