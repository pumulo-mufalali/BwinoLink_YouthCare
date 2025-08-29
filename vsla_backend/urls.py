"""
URL configuration for vsla_backend project.
"""
from django.contrib import admin
from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/v1/', include('users.urls')),
    path('api/v1/', include('health_screening.urls')),
    path('api/v1/', include('rewards.urls')),
    path('api/v1/', include('health_access.urls')),
    path('api/v1/', include('peer_navigation.urls')),
    path('api/v1/', include('notifications.urls')),
    path('api/v1/', include('chat.urls')),
]

if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
    urlpatterns += static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)
