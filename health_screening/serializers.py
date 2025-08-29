from rest_framework import serializers
from .models import ScreeningResult, HealthWorkerProfile
from users.serializers import UserProfileSerializer


class ScreeningResultSerializer(serializers.ModelSerializer):
    """Serializer for screening results"""
    patient_name = serializers.CharField(source='patient.get_full_name', read_only=True)
    patient_phone = serializers.CharField(source='patient.phone_number', read_only=True)
    conducted_by_name = serializers.CharField(source='conducted_by.get_full_name', read_only=True)
    
    class Meta:
        model = ScreeningResult
        fields = [
            'id', 'patient', 'patient_name', 'patient_phone', 'test_type', 'result',
            'date', 'status', 'notes', 'location', 'conducted_by', 'conducted_by_name',
            'requires_follow_up', 'follow_up_instructions', 'follow_up_date',
            'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'date', 'created_at', 'updated_at']


class ScreeningResultCreateSerializer(serializers.ModelSerializer):
    """Serializer for creating new screening results"""
    
    class Meta:
        model = ScreeningResult
        fields = [
            'patient', 'test_type', 'result', 'notes', 'location', 'conducted_by'
        ]
    
    def validate(self, attrs):
        # Ensure the patient is a youth
        if attrs['patient'].role != 'youth':
            raise serializers.ValidationError("Patient must be a youth")
        
        # Ensure the conductor is staff or peer navigator
        if attrs.get('conducted_by') and attrs['conducted_by'].role not in ['staff', 'peer_navigator']:
            raise serializers.ValidationError("Conductor must be staff or peer navigator")
        
        return attrs


class ScreeningResultUpdateSerializer(serializers.ModelSerializer):
    """Serializer for updating screening results"""
    
    class Meta:
        model = ScreeningResult
        fields = [
            'result', 'status', 'notes', 'requires_follow_up', 
            'follow_up_instructions', 'follow_up_date'
        ]


class HealthWorkerProfileSerializer(serializers.ModelSerializer):
    """Serializer for health worker profiles"""
    user = UserProfileSerializer(read_only=True)
    user_id = serializers.IntegerField(write_only=True)
    
    class Meta:
        model = HealthWorkerProfile
        fields = [
            'id', 'user', 'user_id', 'specialization', 'location', 'is_online',
            'availability', 'license_number', 'years_experience', 'languages',
            'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'created_at', 'updated_at']


class HealthWorkerProfileUpdateSerializer(serializers.ModelSerializer):
    """Serializer for updating health worker profiles"""
    
    class Meta:
        model = HealthWorkerProfile
        fields = [
            'specialization', 'location', 'is_online', 'availability',
            'license_number', 'years_experience', 'languages'
        ]


class ScreeningResultFilterSerializer(serializers.Serializer):
    """Serializer for filtering screening results"""
    patient = serializers.IntegerField(required=False)
    test_type = serializers.CharField(required=False)
    status = serializers.CharField(required=False)
    location = serializers.CharField(required=False)
    date_from = serializers.DateField(required=False)
    date_to = serializers.DateField(required=False)
    requires_follow_up = serializers.BooleanField(required=False)


class HealthWorkerAvailabilitySerializer(serializers.Serializer):
    """Serializer for updating health worker availability"""
    availability = serializers.ChoiceField(choices=HealthWorkerProfile.AVAILABILITY_CHOICES)
    is_online = serializers.BooleanField(required=False)
