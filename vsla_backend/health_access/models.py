from django.db import models
from users.models import UserProfile


class HealthAccessPoint(models.Model):
    """Health access points for youth healthcare services"""
    
    TYPE_CHOICES = [
        ('market', 'Market'),
        ('school', 'School'),
        ('youth_center', 'Youth Center'),
        ('clinic', 'Clinic'),
        ('hospital', 'Hospital'),
        ('community_center', 'Community Center'),
    ]
    
    name = models.CharField(max_length=200)
    type = models.CharField(max_length=20, choices=TYPE_CHOICES)
    location = models.CharField(max_length=200)
    address = models.TextField(blank=True)
    coordinates = models.CharField(max_length=100, blank=True, help_text="Latitude,Longitude")
    
    # Services offered
    services = models.JSONField(default=list, help_text="List of available health services")
    
    # Contact information
    contact_person = models.CharField(max_length=200)
    phone_number = models.CharField(max_length=20)
    email = models.EmailField(blank=True, null=True)
    
    # Operational details
    is_active = models.BooleanField(default=True)
    schedule = models.JSONField(default=dict, help_text="Weekly schedule in JSON format")
    
    # Additional information
    description = models.TextField(blank=True)
    facilities = models.JSONField(default=list, help_text="Available facilities")
    accessibility_features = models.JSONField(default=list, help_text="Accessibility features")
    
    # Timestamps
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        verbose_name = 'Health Access Point'
        verbose_name_plural = 'Health Access Points'
        ordering = ['name', 'type']
        indexes = [
            models.Index(fields=['type', 'is_active']),
            models.Index(fields=['location']),
        ]
    
    def __str__(self):
        return f"{self.name} ({self.get_type_display()}) - {self.location}"
    
    def get_available_services(self):
        """Get list of available services"""
        return self.services if self.services else []
    
    def is_open_on_day(self, day):
        """Check if access point is open on a specific day"""
        if not self.schedule:
            return False
        return day.lower() in self.schedule and self.schedule[day.lower()]
    
    def get_schedule_for_day(self, day):
        """Get schedule for a specific day"""
        if not self.schedule:
            return None
        return self.schedule.get(day.lower())


class AccessPointService(models.Model):
    """Individual services offered at health access points"""
    
    SERVICE_CHOICES = [
        ('Blood Pressure', 'Blood Pressure'),
        ('Blood Sugar', 'Blood Sugar'),
        ('BMI', 'BMI'),
        ('HIV Self-Test', 'HIV Self-Test'),
        ('Contraceptive Counseling', 'Contraceptive Counseling'),
        ('Mental Health Screening', 'Mental Health Screening'),
        ('Pregnancy Test', 'Pregnancy Test'),
        ('STI Information', 'STI Information'),
        ('Nutrition Assessment', 'Nutrition Assessment'),
        ('Physical Activity Check', 'Physical Activity Check'),
        ('Vaccination', 'Vaccination'),
        ('First Aid', 'First Aid'),
        ('Health Education', 'Health Education'),
    ]
    
    name = models.CharField(max_length=100, choices=SERVICE_CHOICES, unique=True)
    description = models.TextField()
    is_active = models.BooleanField(default=True)
    
    class Meta:
        verbose_name = 'Access Point Service'
        verbose_name_plural = 'Access Point Services'
        ordering = ['name']
    
    def __str__(self):
        return self.name


class AccessPointSchedule(models.Model):
    """Detailed schedule for health access points"""
    
    DAY_CHOICES = [
        ('monday', 'Monday'),
        ('tuesday', 'Tuesday'),
        ('wednesday', 'Wednesday'),
        ('thursday', 'Thursday'),
        ('friday', 'Friday'),
        ('saturday', 'Saturday'),
        ('sunday', 'Sunday'),
    ]
    
    access_point = models.ForeignKey(HealthAccessPoint, on_delete=models.CASCADE, related_name='detailed_schedules')
    day = models.CharField(max_length=10, choices=DAY_CHOICES)
    open_time = models.TimeField()
    close_time = models.TimeField()
    is_closed = models.BooleanField(default=False)
    notes = models.CharField(max_length=200, blank=True)
    
    class Meta:
        verbose_name = 'Access Point Schedule'
        verbose_name_plural = 'Access Point Schedules'
        unique_together = ['access_point', 'day']
        ordering = ['day']
    
    def __str__(self):
        if self.is_closed:
            return f"{self.access_point.name} - {self.get_day_display()} (Closed)"
        return f"{self.access_point.name} - {self.get_day_display()} ({self.open_time} - {self.close_time})"
    
    def is_currently_open(self):
        """Check if access point is currently open"""
        from django.utils import timezone
        now = timezone.now().time()
        return self.open_time <= now <= self.close_time
