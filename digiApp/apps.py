from django.apps import AppConfig


class DigiappConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'digiApp'

    def ready(self):
        import digiApp.signals  # Ensure this matches your app's name





