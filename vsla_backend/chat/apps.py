from django.apps import AppConfig


class ChatConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'vsla_backend.chat'
    verbose_name = 'Chat Management'
