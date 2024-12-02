from django.db import models
from django.contrib.auth.models import User
from django.utils import timezone



class Product(models.Model):
    title = models.CharField(max_length=255)
    description = models.TextField()
    price = models.DecimalField(max_digits=10, decimal_places=2)
    affiliate_link = models.URLField(blank=True, null=True)
    is_approved = models.BooleanField(default=True)
    created_at = models.DateTimeField(default=timezone.now)
    updated_at = models.DateTimeField(auto_now=True)
    image = models.URLField(default='https://res.cloudinary.com/your-cloud-name/image/upload/v1606355678/default-placeholder.jpg', blank=True, null=True)

    def __str__(self):
        return self.title

    def delete(self, *args, **kwargs):
        # Delete the image from Cloudinary if it exists
        if self.image:
            try:
                # Cloudinary expects the public ID, so you need to extract it from the image URL
                public_id = self.image.name.split('/')[-1].split('.')[0]
                destroy(public_id=public_id)  # Deletes the image from Cloudinary
            except Exception as e:
                print(f"Error deleting image from Cloudinary: {e}")
        
        # Proceed with the normal deletion process
        super().delete(*args, **kwargs)


class Profile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    phone_number = models.CharField(max_length=15, blank=True, null=True)
    profile_picture = models.ImageField(upload_to='profile_pics/', blank=True, null=True)
    address = models.TextField(blank=True, null=True)
    company = models.CharField(max_length=255, blank=True, null=True)
    country = models.CharField(max_length=100, blank=True, null=True)
    role = models.CharField(max_length=100, blank=True, null=True)
    about = models.TextField(blank=True, null=True)
    full_name = models.CharField(max_length=255, blank=True, null=True)  # New field

    def __str__(self):
        return f"{self.user.username}'s Profile"



