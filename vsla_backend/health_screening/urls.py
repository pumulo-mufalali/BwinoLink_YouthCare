from django.urls import path
from . import views

app_name = 'health_screening'

urlpatterns = [
    # Screening results
    path('screenings/', views.ScreeningResultListCreateView.as_view(), name='screening-list-create'),
    path('screenings/<int:pk>/', views.ScreeningResultDetailView.as_view(), name='screening-detail'),
    path('screenings/patient/<int:patient_id>/history/', views.PatientScreeningHistoryView.as_view(), name='patient-history'),
    path('screenings/abnormal/', views.AbnormalResultsView.as_view(), name='abnormal-results'),
    path('screenings/<int:screening_id>/follow-up/', views.schedule_follow_up, name='schedule-follow-up'),
    
    # Health worker profiles
    path('health-workers/', views.HealthWorkerListView.as_view(), name='health-worker-list'),
    path('health-workers/profile/', views.HealthWorkerProfileView.as_view(), name='health-worker-profile'),
    path('health-workers/availability/', views.HealthWorkerAvailabilityView.as_view(), name='health-worker-availability'),
    
    # Statistics
    path('screenings/statistics/', views.screening_statistics, name='screening-statistics'),
]
