from django.db import models
from django.contrib.auth.models import AbstractUser
from django.core.validators import MinValueValidator, MaxValueValidator


class UserProfile(AbstractUser):
    """Extended user model for VSLA youth healthcare platform"""
    
    ROLE_CHOICES = [
        ('youth', 'Youth'),
        ('staff', 'Staff'),
        ('peer_navigator', 'Peer Navigator'),
        ('vendor', 'Vendor'),
    ]
    
    # Override username to use phone number
    username = models.CharField(max_length=15, unique=True, help_text="Phone number as username")
    
    # Basic profile fields
    phone_number = models.CharField(max_length=15, unique=True)
    role = models.CharField(max_length=20, choices=ROLE_CHOICES, default='youth')
    points = models.IntegerField(default=0, validators=[MinValueValidator(0)])
    notifications = models.IntegerField(default=0, validators=[MinValueValidator(0)])
    profile_image = models.ImageField(upload_to='profile_images/', blank=True, null=True)
    age = models.PositiveIntegerField(blank=True, null=True, validators=[MinValueValidator(0), MaxValueValidator(120)])
    location = models.CharField(max_length=200, blank=True)
    interests = models.JSONField(default=list, blank=True)
    is_active = models.BooleanField(default=True)
    
    # Timestamps
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        verbose_name = 'User Profile'
        verbose_name_plural = 'User Profiles'
        ordering = ['-created_at']
    
    def __str__(self):
        return f"{self.get_full_name()} ({self.phone_number})"
    
    def get_full_name(self):
        if self.first_name and self.last_name:
            return f"{self.first_name} {self.last_name}"
        return self.username
    
    def add_points(self, points_to_add):
        """Add points to user's account"""
        self.points += points_to_add
        self.save(update_fields=['points'])
    
    def deduct_points(self, points_to_deduct):
        """Deduct points from user's account"""
        if self.points >= points_to_deduct:
            self.points -= points_to_deduct
            self.save(update_fields=['points'])
            return True
        return False
    
    def increment_notifications(self):
        """Increment notification count"""
        self.notifications += 1
        self.save(update_fields=['notifications'])
    
    def clear_notifications(self):
        """Clear notification count"""
        self.notifications = 0
        self.save(update_fields=['notifications'])
