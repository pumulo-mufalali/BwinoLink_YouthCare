from django.contrib import admin
from .models import ScreeningResult, HealthWorkerProfile


@admin.register(ScreeningResult)
class ScreeningResultAdmin(admin.ModelAdmin):
    """Admin interface for ScreeningResult model"""
    
    list_display = [
        'id', 'patient', 'test_type', 'result', 'status', 'location',
        'conducted_by', 'requires_follow_up', 'date', 'created_at'
    ]
    
    list_filter = [
        'status', 'test_type', 'location', 'requires_follow_up',
        'date', 'created_at', 'patient__role'
    ]
    
    search_fields = [
        'patient__first_name', 'patient__last_name', 'patient__phone_number',
        'conducted_by__first_name', 'conducted_by__last_name', 'notes'
    ]
    
    ordering = ['-date', '-created_at']
    
    readonly_fields = ['created_at', 'updated_at']
    
    fieldsets = (
        ('Basic Information', {
            'fields': ('patient', 'test_type', 'result', 'status', 'date')
        }),
        ('Location & Conductor', {
            'fields': ('location', 'conducted_by')
        }),
        ('Medical Details', {
            'fields': ('notes', 'requires_follow_up', 'follow_up_instructions', 'follow_up_date')
        }),
        ('Timestamps', {
            'fields': ('created_at', 'updated_at'),
            'classes': ('collapse',)
        }),
    )
    
    def get_queryset(self, request):
        return super().get_queryset(request).select_related('patient', 'conducted_by')


@admin.register(HealthWorkerProfile)
class HealthWorkerProfileAdmin(admin.ModelAdmin):
    """Admin interface for HealthWorkerProfile model"""
    
    list_display = [
        'user', 'specialization', 'location', 'is_online', 'availability',
        'years_experience', 'created_at'
    ]
    
    list_filter = [
        'specialization', 'location', 'is_online', 'availability',
        'years_experience', 'created_at'
    ]
    
    search_fields = [
        'user__first_name', 'user__last_name', 'user__phone_number',
        'specialization', 'location', 'license_number'
    ]
    
    ordering = ['-created_at']
    
    readonly_fields = ['created_at', 'updated_at']
    
    fieldsets = (
        ('User Information', {
            'fields': ('user',)
        }),
        ('Professional Details', {
            'fields': ('specialization', 'license_number', 'years_experience')
        }),
        ('Location & Availability', {
            'fields': ('location', 'is_online', 'availability')
        }),
        ('Additional Information', {
            'fields': ('languages',)
        }),
        ('Timestamps', {
            'fields': ('created_at', 'updated_at'),
            'classes': ('collapse',)
        }),
    )
    
    def get_queryset(self, request):
        return super().get_queryset(request).select_related('user')
