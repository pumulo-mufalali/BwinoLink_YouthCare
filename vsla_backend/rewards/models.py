from django.db import models
from django.core.validators import MinValueValidator
from users.models import UserProfile


class RewardItem(models.Model):
    """Reward items that users can redeem with points"""
    
    CATEGORY_CHOICES = [
        ('health', 'Health'),
        ('transport', 'Transport'),
        ('market', 'Market'),
        ('entertainment', 'Entertainment'),
        ('education', 'Education'),
    ]
    
    name = models.CharField(max_length=200)
    description = models.TextField()
    points_required = models.IntegerField(validators=[MinValueValidator(1)])
    image_url = models.URLField(blank=True, null=True)
    is_available = models.BooleanField(default=True)
    category = models.CharField(max_length=20, choices=CATEGORY_CHOICES, default='health')
    redemption_code = models.CharField(max_length=50, unique=True)
    expiry_duration_days = models.IntegerField(default=30, validators=[MinValueValidator(1)])
    
    # Timestamps
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        verbose_name = 'Reward Item'
        verbose_name_plural = 'Reward Items'
        ordering = ['points_required', 'name']
    
    def __str__(self):
        return f"{self.name} ({self.points_required} points)"
    
    def is_expired(self, redemption_date):
        """Check if reward is expired based on redemption date"""
        from django.utils import timezone
        expiry_date = redemption_date + timezone.timedelta(days=self.expiry_duration_days)
        return timezone.now() > expiry_date


class Achievement(models.Model):
    """Gamification achievements for users"""
    
    name = models.CharField(max_length=200)
    description = models.TextField()
    points_rewarded = models.IntegerField(validators=[MinValueValidator(0)])
    icon = models.CharField(max_length=50, blank=True)
    is_unlocked = models.BooleanField(default=False)
    unlocked_date = models.DateTimeField(null=True, blank=True)
    
    # Timestamps
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        verbose_name = 'Achievement'
        verbose_name_plural = 'Achievements'
        ordering = ['points_rewarded', 'name']
    
    def __str__(self):
        return f"{self.name} ({self.points_rewarded} points)"


class UserReward(models.Model):
    """User reward redemptions and achievements"""
    
    STATUS_CHOICES = [
        ('pending', 'Pending'),
        ('active', 'Active'),
        ('expired', 'Expired'),
        ('used', 'Used'),
    ]
    
    user = models.ForeignKey(UserProfile, on_delete=models.CASCADE, related_name='rewards')
    reward_item = models.ForeignKey(RewardItem, on_delete=models.CASCADE, related_name='redemptions')
    achievement = models.ForeignKey(Achievement, on_delete=models.CASCADE, related_name='user_achievements', null=True, blank=True)
    
    # Redemption details
    redemption_date = models.DateTimeField(auto_now_add=True)
    expiry_date = models.DateTimeField()
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='pending')
    points_spent = models.IntegerField()
    
    # Usage tracking
    used_date = models.DateTimeField(null=True, blank=True)
    notes = models.TextField(blank=True)
    
    # Timestamps
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        verbose_name = 'User Reward'
        verbose_name_plural = 'User Rewards'
        ordering = ['-redemption_date']
        unique_together = ['user', 'reward_item', 'redemption_date']
    
    def __str__(self):
        return f"{self.user.get_full_name()} - {self.reward_item.name}"
    
    def save(self, *args, **kwargs):
        if not self.expiry_date:
            from django.utils import timezone
            self.expiry_date = timezone.now() + timezone.timedelta(days=self.reward_item.expiry_duration_days)
        super().save(*args, **kwargs)
    
    def is_expired(self):
        """Check if the reward is expired"""
        from django.utils import timezone
        return timezone.now() > self.expiry_date
    
    def mark_as_used(self):
        """Mark the reward as used"""
        from django.utils import timezone
        self.status = 'used'
        self.used_date = timezone.now()
        self.save(update_fields=['status', 'used_date'])


class UserAchievement(models.Model):
    """User achievement tracking"""
    
    user = models.ForeignKey(UserProfile, on_delete=models.CASCADE, related_name='achievements')
    achievement = models.ForeignKey(Achievement, on_delete=models.CASCADE, related_name='users')
    unlocked_date = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        verbose_name = 'User Achievement'
        verbose_name_plural = 'User Achievements'
        unique_together = ['user', 'achievement']
        ordering = ['-unlocked_date']
    
    def __str__(self):
        return f"{self.user.get_full_name()} - {self.achievement.name}"
    
    def save(self, *args, **kwargs):
        # Award points to user when achievement is unlocked
        if not self.pk:  # Only on creation
            self.user.add_points(self.achievement.points_rewarded)
        super().save(*args, **kwargs)
