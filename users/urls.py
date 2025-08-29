from django.urls import path
from . import views

app_name = 'users'

urlpatterns = [
    # Authentication endpoints
    path('auth/register/', views.UserRegistrationView.as_view(), name='user-register'),
    path('auth/login/', views.UserLoginView.as_view(), name='user-login'),
    path('auth/logout/', views.UserLogoutView.as_view(), name='user-logout'),
    
    # Profile management
    path('profile/', views.UserProfileView.as_view(), name='user-profile'),
    path('profile/update/', views.UserProfileUpdateView.as_view(), name='user-profile-update'),
    path('profile/change-password/', views.ChangePasswordView.as_view(), name='change-password'),
    
    # Points management
    path('points/', views.UserPointsView.as_view(), name='user-points'),
    
    # User listings
    path('users/<str:role>/', views.UserListByRoleView.as_view(), name='users-by-role'),
    
    # Notifications
    path('notifications/count/', views.user_notifications_count, name='notifications-count'),
    path('notifications/clear/', views.clear_notifications, name='clear-notifications'),
]
