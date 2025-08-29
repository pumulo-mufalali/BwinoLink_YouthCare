from django.db import models
from users.models import UserProfile


class PeerNavigatorAssignment(models.Model):
    """Peer navigator assignments for youth support"""
    
    STATUS_CHOICES = [
        ('active', 'Active'),
        ('completed', 'Completed'),
        ('discontinued', 'Discontinued'),
        ('pending', 'Pending'),
    ]
    
    SUPPORT_AREA_CHOICES = [
        ('mental_health', 'Mental Health'),
        ('sexual_health', 'Sexual Health'),
        ('physical_health', 'Physical Health'),
        ('nutrition', 'Nutrition'),
        ('substance_abuse', 'Substance Abuse'),
        ('education', 'Education'),
        ('employment', 'Employment'),
        ('social_support', 'Social Support'),
        ('family_planning', 'Family Planning'),
        ('hiv_care', 'HIV Care'),
    ]
    
    youth = models.ForeignKey(
        UserProfile, 
        on_delete=models.CASCADE, 
        related_name='peer_navigator_assignments',
        limit_choices_to={'role': 'youth'}
    )
    peer_navigator = models.ForeignKey(
        UserProfile, 
        on_delete=models.CASCADE, 
        related_name='youth_assignments',
        limit_choices_to={'role': 'peer_navigator'}
    )
    
    # Assignment details
    assigned_date = models.DateTimeField(auto_now_add=True)
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='active')
    support_areas = models.JSONField(default=list, help_text="Areas where support is needed")
    notes = models.TextField(blank=True)
    
    # Support session tracking
    total_sessions = models.PositiveIntegerField(default=0)
    last_session_date = models.DateTimeField(null=True, blank=True)
    next_session_date = models.DateTimeField(null=True, blank=True)
    
    # Progress tracking
    goals = models.JSONField(default=list, help_text="Support goals for the youth")
    progress_notes = models.TextField(blank=True)
    completion_date = models.DateTimeField(null=True, blank=True)
    
    # Timestamps
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        verbose_name = 'Peer Navigator Assignment'
        verbose_name_plural = 'Peer Navigator Assignments'
        ordering = ['-assigned_date']
        unique_together = ['youth', 'peer_navigator', 'status']
        indexes = [
            models.Index(fields=['status', 'assigned_date']),
            models.Index(fields=['youth', 'status']),
            models.Index(fields=['peer_navigator', 'status']),
        ]
    
    def __str__(self):
        return f"{self.youth.get_full_name()} - {self.peer_navigator.get_full_name()} ({self.status})"
    
    def mark_as_completed(self):
        """Mark assignment as completed"""
        from django.utils import timezone
        self.status = 'completed'
        self.completion_date = timezone.now()
        self.save(update_fields=['status', 'completion_date'])
    
    def add_support_session(self, session_date, notes=""):
        """Add a support session"""
        from django.utils import timezone
        self.total_sessions += 1
        self.last_session_date = session_date
        if notes:
            self.progress_notes += f"\n{timezone.now().strftime('%Y-%m-%d %H:%M')}: {notes}"
        self.save(update_fields=['total_sessions', 'last_session_date', 'progress_notes'])
    
    def schedule_next_session(self, next_date):
        """Schedule the next support session"""
        self.next_session_date = next_date
        self.save(update_fields=['next_session_date'])


class SupportSession(models.Model):
    """Individual support sessions between peer navigator and youth"""
    
    SESSION_TYPE_CHOICES = [
        ('initial_assessment', 'Initial Assessment'),
        ('follow_up', 'Follow-up'),
        ('crisis_intervention', 'Crisis Intervention'),
        ('goal_setting', 'Goal Setting'),
        ('progress_review', 'Progress Review'),
        ('referral', 'Referral'),
        ('education', 'Education'),
        ('support_group', 'Support Group'),
    ]
    
    assignment = models.ForeignKey(PeerNavigatorAssignment, on_delete=models.CASCADE, related_name='sessions')
    session_date = models.DateTimeField()
    session_type = models.CharField(max_length=30, choices=SESSION_TYPE_CHOICES)
    duration_minutes = models.PositiveIntegerField(help_text="Session duration in minutes")
    
    # Session content
    topics_discussed = models.JSONField(default=list, help_text="Topics discussed during session")
    goals_set = models.JSONField(default=list, help_text="Goals set during session")
    actions_agreed = models.JSONField(default=list, help_text="Actions agreed upon")
    
    # Session outcomes
    notes = models.TextField(blank=True)
    youth_satisfaction = models.PositiveIntegerField(
        choices=[(i, i) for i in range(1, 6)], 
        null=True, 
        blank=True,
        help_text="Youth satisfaction rating (1-5)"
    )
    follow_up_needed = models.BooleanField(default=False)
    follow_up_notes = models.TextField(blank=True)
    
    # Timestamps
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        verbose_name = 'Support Session'
        verbose_name_plural = 'Support Sessions'
        ordering = ['-session_date']
        indexes = [
            models.Index(fields=['assignment', 'session_date']),
            models.Index(fields=['session_type', 'session_date']),
        ]
    
    def __str__(self):
        return f"{self.assignment} - {self.get_session_type_display()} ({self.session_date.strftime('%Y-%m-%d')})"
    
    def save(self, *args, **kwargs):
        # Update the assignment's last session date
        if not self.pk:  # Only on creation
            self.assignment.last_session_date = self.session_date
            self.assignment.total_sessions += 1
            self.assignment.save(update_fields=['last_session_date', 'total_sessions'])
        super().save(*args, **kwargs)
