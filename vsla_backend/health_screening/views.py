from rest_framework import status, generics, permissions, filters
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from django_filters.rest_framework import DjangoFilterBackend
from django.shortcuts import get_object_or_404
from django.db.models import Q
from .models import ScreeningResult, HealthWorkerProfile
from .serializers import (
    ScreeningResultSerializer, ScreeningResultCreateSerializer,
    ScreeningResultUpdateSerializer, HealthWorkerProfileSerializer,
    HealthWorkerProfileUpdateSerializer, ScreeningResultFilterSerializer,
    HealthWorkerAvailabilitySerializer
)


class ScreeningResultListCreateView(generics.ListCreateAPIView):
    """List and create screening results"""
    queryset = ScreeningResult.objects.all()
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ['patient', 'test_type', 'status', 'location', 'requires_follow_up']
    search_fields = ['patient__first_name', 'patient__last_name', 'notes']
    ordering_fields = ['date', 'created_at', 'status']
    ordering = ['-date']
    
    def get_serializer_class(self):
        if self.request.method == 'POST':
            return ScreeningResultCreateSerializer
        return ScreeningResultSerializer
    
    def get_queryset(self):
        queryset = super().get_queryset()
        
        # Filter by date range if provided
        date_from = self.request.query_params.get('date_from')
        date_to = self.request.query_params.get('date_to')
        
        if date_from:
            queryset = queryset.filter(date__date__gte=date_from)
        if date_to:
            queryset = queryset.filter(date__date__lte=date_to)
        
        # If user is youth, only show their own results
        if self.request.user.role == 'youth':
            queryset = queryset.filter(patient=self.request.user)
        
        return queryset.select_related('patient', 'conducted_by')
    
    def perform_create(self, serializer):
        # Set the conducted_by to the current user if not specified
        if not serializer.validated_data.get('conducted_by'):
            serializer.save(conducted_by=self.request.user)
        else:
            serializer.save()


class ScreeningResultDetailView(generics.RetrieveUpdateDestroyAPIView):
    """Retrieve, update, and delete screening results"""
    queryset = ScreeningResult.objects.all()
    serializer_class = ScreeningResultSerializer
    permission_classes = [permissions.IsAuthenticated]
    
    def get_queryset(self):
        queryset = super().get_queryset()
        # If user is youth, only show their own results
        if self.request.user.role == 'youth':
            queryset = queryset.filter(patient=self.request.user)
        return queryset.select_related('patient', 'conducted_by')
    
    def get_serializer_class(self):
        if self.request.method in ['PUT', 'PATCH']:
            return ScreeningResultUpdateSerializer
        return ScreeningResultSerializer


class PatientScreeningHistoryView(generics.ListAPIView):
    """Get screening history for a specific patient"""
    serializer_class = ScreeningResultSerializer
    permission_classes = [permissions.IsAuthenticated]
    
    def get_queryset(self):
        patient_id = self.kwargs.get('patient_id')
        
        # Staff and peer navigators can view any patient's history
        if self.request.user.role in ['staff', 'peer_navigator']:
            return ScreeningResult.objects.filter(patient_id=patient_id).select_related('patient', 'conducted_by')
        
        # Youth can only view their own history
        if self.request.user.role == 'youth' and str(self.request.user.id) == str(patient_id):
            return ScreeningResult.objects.filter(patient_id=patient_id).select_related('patient', 'conducted_by')
        
        return ScreeningResult.objects.none()


class AbnormalResultsView(generics.ListAPIView):
    """Get all abnormal results that require follow-up"""
    serializer_class = ScreeningResultSerializer
    permission_classes = [permissions.IsAuthenticated]
    
    def get_queryset(self):
        queryset = ScreeningResult.objects.filter(
            Q(status='abnormal') | Q(requires_follow_up=True)
        ).select_related('patient', 'conducted_by')
        
        # If user is youth, only show their own abnormal results
        if self.request.user.role == 'youth':
            queryset = queryset.filter(patient=self.request.user)
        
        return queryset


class HealthWorkerProfileView(generics.RetrieveUpdateAPIView):
    """Health worker profile management"""
    serializer_class = HealthWorkerProfileSerializer
    permission_classes = [permissions.IsAuthenticated]
    
    def get_object(self):
        # Users can only access their own profile
        return get_object_or_404(HealthWorkerProfile, user=self.request.user)
    
    def get_serializer_class(self):
        if self.request.method in ['PUT', 'PATCH']:
            return HealthWorkerProfileUpdateSerializer
        return HealthWorkerProfileSerializer


class HealthWorkerListView(generics.ListAPIView):
    """List all health workers"""
    serializer_class = HealthWorkerProfileSerializer
    permission_classes = [permissions.IsAuthenticated]
    filter_backends = [DjangoFilterBackend, filters.SearchFilter]
    filterset_fields = ['specialization', 'location', 'availability', 'is_online']
    search_fields = ['user__first_name', 'user__last_name', 'specialization']
    
    def get_queryset(self):
        return HealthWorkerProfile.objects.filter(
            user__is_active=True
        ).select_related('user')


class HealthWorkerAvailabilityView(generics.UpdateAPIView):
    """Update health worker availability"""
    serializer_class = HealthWorkerAvailabilitySerializer
    permission_classes = [permissions.IsAuthenticated]
    
    def get_object(self):
        return get_object_or_404(HealthWorkerProfile, user=self.request.user)
    
    def perform_update(self, serializer):
        health_worker = serializer.save()
        # Update is_online based on availability
        if serializer.validated_data.get('availability') == 'available':
            health_worker.is_online = True
        else:
            health_worker.is_online = False
        health_worker.save(update_fields=['is_online'])


@api_view(['GET'])
@permission_classes([permissions.IsAuthenticated])
def screening_statistics(request):
    """Get screening statistics for the platform"""
    if request.user.role not in ['staff', 'peer_navigator']:
        return Response({'error': 'Insufficient permissions'}, status=status.HTTP_403_FORBIDDEN)
    
    total_screenings = ScreeningResult.objects.count()
    normal_results = ScreeningResult.objects.filter(status='normal').count()
    abnormal_results = ScreeningResult.objects.filter(status='abnormal').count()
    pending_results = ScreeningResult.objects.filter(status='pending').count()
    follow_up_needed = ScreeningResult.objects.filter(requires_follow_up=True).count()
    
    # Get counts by test type
    test_type_counts = {}
    for test_type in ScreeningResult.TEST_TYPE_CHOICES:
        test_type_counts[test_type[0]] = ScreeningResult.objects.filter(test_type=test_type[0]).count()
    
    return Response({
        'total_screenings': total_screenings,
        'normal_results': normal_results,
        'abnormal_results': abnormal_results,
        'pending_results': pending_results,
        'follow_up_needed': follow_up_needed,
        'test_type_breakdown': test_type_counts
    })


@api_view(['POST'])
@permission_classes([permissions.IsAuthenticated])
def schedule_follow_up(request, screening_id):
    """Schedule a follow-up for a screening result"""
    if request.user.role not in ['staff', 'peer_navigator']:
        return Response({'error': 'Insufficient permissions'}, status=status.HTTP_403_FORBIDDEN)
    
    screening = get_object_or_404(ScreeningResult, id=screening_id)
    follow_up_date = request.data.get('follow_up_date')
    instructions = request.data.get('follow_up_instructions', '')
    
    if not follow_up_date:
        return Response({'error': 'Follow-up date is required'}, status=status.HTTP_400_BAD_REQUEST)
    
    screening.schedule_follow_up(follow_up_date, instructions)
    
    return Response({
        'message': 'Follow-up scheduled successfully',
        'screening': ScreeningResultSerializer(screening).data
    })
