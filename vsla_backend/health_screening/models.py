from django.db import models
from django.core.validators import MinValueValidator, MaxValueValidator
from vsla_backend.users.models import UserProfile


class ScreeningResult(models.Model):
    """Health screening results for youth healthcare platform"""
    
    STATUS_CHOICES = [
        ('normal', 'Normal'),
        ('abnormal', 'Abnormal'),
        ('pending', 'Pending'),
        ('follow_up_needed', 'Follow Up Needed'),
    ]
    
    LOCATION_CHOICES = [
        ('market', 'Market'),
        ('school', 'School'),
        ('youth_center', 'Youth Center'),
        ('clinic', 'Clinic'),
        ('hospital', 'Hospital'),
    ]
    
    TEST_TYPE_CHOICES = [
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
    ]
    
    # Basic screening information
    id = models.AutoField(primary_key=True)
    patient = models.ForeignKey(
        UserProfile, 
        on_delete=models.CASCADE, 
        related_name='screening_results',
        limit_choices_to={'role': 'youth'}
    )
    test_type = models.CharField(max_length=50, choices=TEST_TYPE_CHOICES)
    result = models.CharField(max_length=200)
    date = models.DateTimeField(auto_now_add=True)
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='pending')
    
    # Additional details
    notes = models.TextField(blank=True)
    location = models.CharField(max_length=20, choices=LOCATION_CHOICES, default='clinic')
    conducted_by = models.ForeignKey(
        UserProfile, 
        on_delete=models.SET_NULL, 
        null=True, 
        blank=True,
        related_name='conducted_screenings',
        limit_choices_to={'role__in': ['staff', 'peer_navigator']}
    )
    
    # Follow-up information
    requires_follow_up = models.BooleanField(default=False)
    follow_up_instructions = models.TextField(blank=True)
    follow_up_date = models.DateTimeField(null=True, blank=True)
    
    # Timestamps
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        verbose_name = 'Screening Result'
        verbose_name_plural = 'Screening Results'
        ordering = ['-date']
        indexes = [
            models.Index(fields=['patient', 'date']),
            models.Index(fields=['status', 'date']),
            models.Index(fields=['test_type', 'date']),
        ]
    
    def __str__(self):
        return f"{self.patient.get_full_name()} - {self.test_type} ({self.status})"
    
    def save(self, *args, **kwargs):
        # Auto-update status based on result
        if self.result and self.status == 'pending':
            if 'normal' in self.result.lower() or self.result.isdigit():
                self.status = 'normal'
            else:
                self.status = 'abnormal'
                self.requires_follow_up = True
        
        super().save(*args, **kwargs)
    
    def get_abnormal_results(self):
        """Get all abnormal results for this patient"""
        return ScreeningResult.objects.filter(
            patient=self.patient,
            status__in=['abnormal', 'follow_up_needed']
        )
    
    def schedule_follow_up(self, date, instructions):
        """Schedule a follow-up appointment"""
        self.follow_up_date = date
        self.follow_up_instructions = instructions
        self.requires_follow_up = True
        self.save(update_fields=['follow_up_date', 'follow_up_instructions', 'requires_follow_up'])


class HealthWorkerProfile(models.Model):
    """Health worker profiles for the platform"""
    
    SPECIALIZATION_CHOICES = [
        ('general', 'General'),
        ('hiv_counselor', 'HIV Counselor'),
        ('mental_health', 'Mental Health'),
        ('sexual_health', 'Sexual Health'),
        ('pediatric', 'Pediatric'),
        ('nutrition', 'Nutrition'),
    ]
    
    AVAILABILITY_CHOICES = [
        ('available', 'Available'),
        ('busy', 'Busy'),
        ('offline', 'Offline'),
    ]
    
    user = models.OneToOneField(
        UserProfile, 
        on_delete=models.CASCADE, 
        related_name='health_worker_profile'
    )
    specialization = models.CharField(max_length=20, choices=SPECIALIZATION_CHOICES)
    location = models.CharField(max_length=200)
    is_online = models.BooleanField(default=False)
    availability = models.CharField(max_length=20, choices=AVAILABILITY_CHOICES, default='offline')
    
    # Additional professional info
    license_number = models.CharField(max_length=50, blank=True)
    years_experience = models.PositiveIntegerField(default=0)
    languages = models.JSONField(default=list, blank=True)
    
    # Timestamps
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        verbose_name = 'Health Worker Profile'
        verbose_name_plural = 'Health Worker Profiles'
        ordering = ['-created_at']
    
    def __str__(self):
        return f"Dr. {self.user.get_full_name()} - {self.specialization}"
    
    def set_availability(self, status):
        """Set health worker availability"""
        self.availability = status
        self.is_online = status == 'available'
        self.save(update_fields=['availability', 'is_online'])
    
    def get_available_slots(self):
        """Get available appointment slots (placeholder for future implementation)"""
        # This would integrate with a scheduling system
        return []
