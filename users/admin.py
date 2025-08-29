from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from .models import UserProfile


@admin.register(UserProfile)
class UserProfileAdmin(UserAdmin):
    """Admin interface for UserProfile model"""
    
    list_display = [
        'username', 'first_name', 'last_name', 'phone_number', 'role',
        'points', 'notifications', 'age', 'location', 'is_active', 'created_at'
    ]
    
    list_filter = [
        'role', 'is_active', 'created_at', 'updated_at', 'age'
    ]
    
    search_fields = [
        'username', 'first_name', 'last_name', 'phone_number', 'email'
    ]
    
    ordering = ['-created_at']
    
    fieldsets = (
        (None, {'fields': ('username', 'password')}),
        ('Personal info', {
            'fields': (
                'first_name', 'last_name', 'email', 'phone_number',
                'profile_image', 'age', 'location', 'interests'
            )
        }),
        ('VSLA Settings', {
            'fields': ('role', 'points', 'notifications', 'is_active')
        }),
        ('Permissions', {
            'fields': (
                'is_active', 'is_staff', 'is_superuser',
                'groups', 'user_permissions'
            ),
        }),
        ('Important dates', {'fields': ('last_login', 'date_joined')}),
    )
    
    add_fieldsets = (
        (None, {
            'classes': ('wide',),
            'fields': (
                'username', 'phone_number', 'password1', 'password2',
                'first_name', 'last_name', 'email', 'role'
            ),
        }),
    )
    
    readonly_fields = ['created_at', 'updated_at', 'last_login', 'date_joined']
    
    def get_queryset(self, request):
        return super().get_queryset(request).select_related()
