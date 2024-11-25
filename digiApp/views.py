from django.shortcuts import render, redirect, get_object_or_404
from .models import Product
from django.contrib.auth.models import User
from django.contrib.auth import authenticate, login, logout
from .decorators import unauthenticated_user, allowed_users, admin_only
from django.contrib.auth.models import Group
from django.contrib.auth.decorators import login_required
from django.contrib import messages
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from .models import Profile
from django.core.exceptions import ObjectDoesNotExist
from django.http import JsonResponse
from django.contrib.auth.password_validation import validate_password
from django.core.exceptions import ValidationError
from sweetify import success, error
import sweetify
from django.core.mail import send_mail
from datetime import datetime


# Functionality to render the product view page
@login_required
@allowed_users(allowed_roles=['admin'])
def products(request):
    # Logic to retrieve and display products
    products = Product.objects.all()

    return render(request, 'digiApp/products.html', {'products': products})

# Home page, accessible to everyone but with authentication check
def homepg(request):
    products = Product.objects.all()
    return render(request, 'digiApp/index.html', {'products': products})

# Functionality to call form (admin only)
@login_required
@allowed_users(allowed_roles=['admin'])
def createProduct(request):
    return render(request, 'digiApp/admin-portal/adcreate_prod.html')

# Functionality to store product record in DB (admin only)
@login_required
@allowed_users(allowed_roles=['admin'])
def storeProduct(request):
    if request.method == 'POST':
        title = request.POST.get('title')
        description = request.POST.get('description')
        price = request.POST.get('price')
        affiliate_link = request.POST.get('affiliate_link')
        image = request.FILES.get('image')

        try:
            # Create and save the Product object
            newProduct = Product(
                title=title,
                description=description,
                price=price,
                affiliate_link=affiliate_link,
                image=image
            )
            newProduct.save()

            # Sweetify success message
            sweetify.success(
                request,
                "Product Created!",
                text="The product has been successfully created and saved.",
                persistent="Ok",
                timer=3000
            )

            # Redirect to admin page or any other page
            return redirect('app.view_products')

        except Exception as e:
            # Show Sweetify error message in case of failure
            sweetify.error(
                request,
                "Product Creation Failed",
                text=f"An error occurred: {e}",
                persistent="Retry",
                timer=3000
            )

            # You can also redirect to the form again if needed
            return redirect('app.view_products')  # Replace with your URL name for this page

    # If the request method is GET, render the product creation form
    return render(request, 'digiApp/admin-portal/adcreate_prod.html')



# Functionality to edit product (admin only)
@login_required
@allowed_users(allowed_roles=['admin'])
def editProduct(request, id):
    product = get_object_or_404(Product, id=id)
    return render(request, 'digiApp/admin-portal/edit_product.html', {'product': product})

# Functionality to update the record in the DB (admin only)
@login_required
@allowed_users(allowed_roles=['admin'])
def updateProduct(request, id):
    product = get_object_or_404(Product, id=id)

    if request.method == 'POST':
        try:
            # Get form data
            title = request.POST.get('title')
            description = request.POST.get('description')
            price = request.POST.get('price')
            affiliate_link = request.POST.get('affiliate_link')
            image = request.FILES.get('image')

            # Update fields in the product instance
            product.title = title
            product.description = description
            product.price = price
            product.affiliate_link = affiliate_link

            if image:
                product.image = image

            # Save the product
            product.save()

            # Display success message using Sweetify
            sweetify.success(
                request,
                'Product updated successfully!',
                text="The product details have been updated.",
                persistent="Okay",
                timer=3000
            )
        except Exception as e:
            # Handle errors and display error message using Sweetify
            sweetify.error(
                request,
                'An error occurred:',
                text=f"Error: {str(e)}",
                persistent="Close",
                timer=3000
            )

        # Redirect to the page that shows products (or another relevant page)
        return redirect('app.view_products')  # Replace with actual view name for viewing products

    # If the request method is GET, render the edit product form with product details
    return render(request, 'digiApp/admin-portal/adcreate_prod.html', {'product': product})

# Functionality to delete product (admin only)
@login_required
@allowed_users(allowed_roles=['admin'])
def destroyProduct(request, id):
    product = get_object_or_404(Product, id=id)

    # Check if this is a GET request after confirmation
    try:
        product.delete()
        # Show success message
        sweetify.success(
            request,
            'Product deleted successfully!',
            text="The product has been removed from the database.",
            persistent="Okay",
            timer=3000
        )
    except Exception as e:
        # Handle errors and show error message
        sweetify.error(
            request,
            'Deletion failed!',
            text=f"Error: {str(e)}",
            persistent="Close",
            timer=3000
        )

    return redirect('app.view_products')


"""
User Authentication system
"""

# Sign-up view: renders the sign-up form
@unauthenticated_user
def signUp(request):
    return render(request, 'digiApp/security/signup.html')

# Register functionality to save user in DB
@unauthenticated_user
def register(request):
    if request.method == 'POST':
        fname = request.POST.get('fname')
        lname = request.POST.get('lname')
        username = request.POST.get('username')
        email = request.POST.get('email')
        pass1 = request.POST.get('password1')
        pass2 = request.POST.get('password2')

        # Check if username or email already exists
        if User.objects.filter(username=username).exists():
            messages.warning(request, "Username already exists. Please choose a different username.")
            return redirect('security.register')

        if User.objects.filter(email=email).exists():
            messages.warning(request, "Email already exists. Please use a different email.")
            return redirect('security.register')

        # Check if passwords match
        if pass1 == pass2:
            # Create user and save to DB
            newUser = User.objects.create_user(username=username, email=email, password=pass1)
            newUser.first_name = fname
            newUser.last_name = lname
            newUser.save()

            # Add the new user to the 'customer' group
            group = Group.objects.get(name='customer')
            newUser.groups.add(group)

            # Don't log the user in, just show success message
            messages.success(request, "Registration successful! Please log in to continue.")
            return redirect('security.login')  # Redirect to the login page

        else:
            messages.warning(request, "Passwords do not match.")
            return redirect('security.register')

    return render(request, 'digiApp/security/signup.html')

# Sign-in view: renders the login form
@unauthenticated_user
def signIn(request):
    return render(request, 'digiApp/security/login.html')

# Login functionality for authenticated user
@unauthenticated_user
def logIn(request):
    if request.method == 'POST':
        username = request.POST.get('username')
        password = request.POST.get('password')

        # Authenticate the user
        user = authenticate(request, username=username, password=password)

        if user is not None:
            # Log the user in
            login(request, user)
            
            # Success message using Bootstrap alert
            messages.success(request, f"Login successful! Welcome back, {user.username}.")

            # Redirect based on user role
            if user.groups.filter(name='admin').exists():
                return redirect('app.admin')  # Redirect admins to admin page
            else:
                return redirect('app.home')  # Redirect customers to user dashboard
        else:
            # Error message using Bootstrap alert
            messages.error(request, "Invalid credentials or user not registered. Please try again.")
            return redirect('security.sign_in')

    return render(request, 'digiApp/security/login.html')


## user restriction
def no_permission(request):
    return render(request, 'digiApp/no_permission.html')

# Logout functionality
def signOut(request):
    if request.user.is_authenticated:
        if request.user.is_staff:  # Check if the user is an admin
            logout(request)
            return redirect('app.home')  # Redirect to the form page for admins
        else:
            logout(request)
            return redirect('app.home')  # Replace 'homepage' with your actual homepage URL name
    return redirect('app.home')  # Default redirect if the user is not authenticated


# Admin portal home functionality
@login_required
@allowed_users(allowed_roles=['admin'])
def adminHome(request):
    # Determine the greeting based on the time of day
    current_hour = datetime.now().hour
    if current_hour < 12:
        greeting = "Good Morning"
        icon = "🌞"  # Sun icon
    elif 12 <= current_hour < 18:
        greeting = "Good Afternoon"
        icon = "☀️"  # Bright sun icon
    else:
        greeting = "Good Evening"
        icon = "🌙"  # Moon icon

    # Pass greeting and icon to the template
    return render(request, 'digiApp/admin-portal/adhome.html', {
        'greeting': greeting,
        'icon': icon,
    })



@login_required
def profile_page(request):
    user = request.user
    profile, created = Profile.objects.get_or_create(user=user)

    
    profile.refresh_from_db()

    if request.method == "POST" and request.is_ajax():  # Handle AJAX request
        profile.full_name = request.POST.get("full_name", profile.full_name)
        profile.about = request.POST.get("about", profile.about)
        profile.company = request.POST.get("company", profile.company)
        profile.role = request.POST.get("role", profile.role)
        profile.country = request.POST.get("country", profile.country)
        profile.address = request.POST.get("address", profile.address)
        profile.phone_number = request.POST.get("phone_number", profile.phone_number)
        
        if request.FILES.get("profile_picture"):
            profile.profile_picture = request.FILES["profile_picture"]

        # user email
        user.email = request.POST.get("email", user.email)
        user.save()
        profile.save()

    return render(request, "digiApp/admin-portal/profile_page.html", {"profile": profile})


@login_required
def edit_profile(request):
    if request.method == "POST":
        user = request.user
        profile = user.profile

        # Update profile fields
        profile.full_name = request.POST.get("full_name")
        profile.about = request.POST.get("about")
        profile.company = request.POST.get("company")
        profile.role = request.POST.get("role")
        profile.country = request.POST.get("country")
        profile.address = request.POST.get("address")
        profile.phone_number = request.POST.get("phone_number")

        # Handle profile picture update
        if "profile_picture" in request.FILES:
            profile.profile_picture = request.FILES["profile_picture"]

        try:
            profile.save()
            user.email = request.POST.get("email")
            user.save()

            # Add Sweetify success message
            sweetify.success(
                request,
                "Profile Updated!",
                text="Your profile was successfully updated.",
                persistent="Ok",
                timer=1000
            )
        except Exception as e:
            # Add Sweetify error message
            sweetify.error(
                request,
                "Update Failed",
                text=f"An error occurred: {e}",
                persistent="Retry",
                timer=1000
            )

        return redirect("profile_page")

    return render(request, "digiApp/admin-portal/profile_page.html", {"user": request.user})







from django.contrib.auth import get_user_model
from django.core.mail import send_mail
from django.shortcuts import render, redirect
from django.urls import reverse
from django.utils.http import urlsafe_base64_encode
from django.contrib.auth.tokens import default_token_generator

def custom_password_reset(request):
    if request.method == 'POST':
        # Get the email from the POST request
        email = request.POST.get('email')
        
        # Check if any user exists with this email
        users = get_user_model().objects.filter(email=email)

        if users.exists():
            # If multiple users exist with the same email, send a password reset to all of them
            for user in users:
                token = default_token_generator.make_token(user)
                uid = urlsafe_base64_encode(str(user.pk).encode())
                reset_url = reverse('password_reset_confirm', kwargs={'uidb64': uid, 'token': token})
                reset_link = request.build_absolute_uri(reset_url)

                send_mail(
                    'Password Reset Request',
                    f'Click the link below to reset your password:\n\n{reset_link}',
                    'noreply@yourdomain.com',
                    [email],
                    fail_silently=False,
                )

            # After sending the email, render the reset done page
            return render(request, 'digiApp/security/password_reset_done.html')

        # If no users are found with the provided email, you could display an error
        else:
            # You can add a message to the template or handle it as needed
            return render(request, 'security/password_reset.html', {'error': 'No user found with this email.'})

    return render(request, 'digiApp/security/password_reset.html')
