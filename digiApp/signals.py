from django.db.models.signals import post_save
from django.dispatch import receiver
from django.contrib.auth.models import User
from .models import Profile

@receiver(post_save, sender=User)
def create_or_update_profile(sender, instance, created, **kwargs):
    if created:
        # Create profile for new user
        Profile.objects.create(user=instance)
    else:
        # Save profile if it exists
        if hasattr(instance, 'profile'):
            instance.profile.save()

# Script to create profiles for existing users (optional)
def create_profiles_for_existing_users():
    for user in User.objects.all():
        if not hasattr(user, 'profile'):  # Check if profile exists
            Profile.objects.create(user=user)
