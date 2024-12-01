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
@login_required(login_url='/security/sign_in/')
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


from django.core.mail import EmailMessage

# Register functionality to save user in DB
@unauthenticated_user
def register(request):
    if request.method == 'POST':
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
            newUser.save()

            # Add the new user to the 'customer' group
            group = Group.objects.get(name='customer')
            newUser.groups.add(group)

            # Prepare HTML email content
            subject = '🎉 Welcome to Quality Grade Digitals!'
            html_message = f"""
            <!DOCTYPE html>
            <html>
            <head>
                <style>
                    body {{
                        font-family: Arial, sans-serif;
                        line-height: 1.3;
                        color: #333;
                        background-color: #f9f9f9;
                        margin: 0;
                        padding: 0;
                    }}
                    .email-container {{
                        max-width: 600px;
                        margin: 20px auto;
                        padding: 20px;
                        background-color: #ffffff;
                        border: 1px solid #ddd;
                        border-radius: 5px;
                        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
                    }}
                    h1 {{
                        color: #0073e6;
                        text-align: center;
                    }}
                    p {{
                        font-size: 13px;
                    }}
                    .cta {{
                        text-align: center;
                        margin: 20px 0;
                    }}
                    .cta a {{
                        display: inline-block;
                        padding: 10px 20px;
                        background-color: #0073e6;
                        color: white;
                        text-decoration: none;
                        border-radius: 5px;
                        font-weight: bold;
                    }}
                    .cta a:hover {{
                        background-color: #005bb5;
                    }}
                    .footer {{
                        text-align: center;
                        margin-top: 20px;
                        font-size: 12px;
                        color: #888;
                    }}
                </style>
            </head>
            <body>
                <div class="email-container">
                    <h1> Welcome to Quality Grade Digitals!</h1>
                    <p>Hi <strong>{username}</strong>,</p>
                    <p>Thank you for joining <strong>Quality Grade Digitals</strong>. We're thrilled to have you on board!</p>
                    <p>Here's what you can do next:</p>
                    <ul>
                        <li>Log in to your account to explore our platform.</li>
                        <li>Take advantage of our tools and resources to get started.</li>
                    </ul>
                    <div class="cta">
                        <a href="https://yourwebsite.com/login" target="_blank">Log in to your account</a>
                    </div>
                    <p>If you have any questions, feel free to reach out to our support team. We're here to help!</p>
                    <p>Welcome aboard, and let's achieve great things together!</p>
                    <p>Cheers,<br>The Quality Grade Digital Team</p>
                    <div class="footer">
                        &copy; {datetime.now().year} Quality Grade Digital. All rights reserved.
                    </div>
                </div>
            </body>
            </html>
            """

            # Use a custom sender email and name
            from_email = 'Quality Grade Digital <no-reply@qualitygrade.com>'  
            email = EmailMessage(subject, html_message, from_email, [email])
            email.content_subtype = "html"  # Set the content type to HTML
            email.send()

            # Show success message to user
            messages.success(request, "Registration successful! Please log in to continue.")
            return redirect('security.login')

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

    if request.method == "POST":
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



from django.core.mail import send_mail
from django.conf import settings
from django.contrib.auth import get_user_model
from django.contrib import messages
from django.urls import reverse
from django.utils.http import urlsafe_base64_encode
from django.contrib.auth.tokens import default_token_generator
from django.shortcuts import render, redirect

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

                # Prepare the HTML email content
                html_message = f"""
                    <!DOCTYPE html>
                    <html>
                    <head>
                        <style>
                            body {{
                                font-family: Arial, sans-serif;
                                color: #333;
                                background-color: #f9f9f9;
                                padding: 20px;
                            }}
                            .email-container {{
                                background-color: #ffffff;
                                padding: 20px;
                                border-radius: 8px;
                                box-shadow: 0 4px 8px rgba(0,2,2,0.1);
                            }}
                            h1 {{
                                color: #0073e6;
                                text-align: center;
                            }}
                            p {{
                                font-size: 14px;
                            }}
                            .cta-button {{
                                display: inline-block;
                                padding: 12px 25px;
                                background-color: #0073e6;
                                color: white;
                                text-decoration: none;
                                border-radius: 5px;
                                font-weight: bold;
                                margin-top: 20px;
                            }}
                            .cta-button:hover {{
                                background-color: #005bb5;
                            }}
                            .footer {{
                                text-align: center;
                                font-size: 12px;
                                color: #888;
                                margin-top: 30px;
                            }}
                        </style>
                    </head>
                    <body>
                        <div class="email-container">
                            <h1>Password Reset Request</h1>
                            <p>Hello {user.username},</p>
                            <p>We received a request to reset your password for your Quality Grade Digitals account. If you made this request, please click the button below to reset your password:</p>
                            <p><a href="{reset_link}" class="cta-button">Reset My Password</a></p>
                            <p>If you did not request this password reset, please ignore this email.</p>
                            <div class="footer">
                                <p>&copy; {datetime.now().year} Quality Grade Digitals. All rights reserved.</p>
                            </div>
                        </div>
                    </body>
                    </html>
                """

                # Send email (HTML version)
                send_mail(
                    'Password Reset Request',
                    '',  # Plain text body is not needed when using HTML
                    'Quality Grade Digital <no-reply@qualitygrade.com>',  
                    [email],  # Recipient email address
                    fail_silently=False,
                    html_message=html_message  # HTML message
                )

            # Redirect to the password reset done page after sending the emails
            return redirect('password_reset_complete')

        else:
            # If no users are found
            messages.error(request, 'No account found with this email address. Please try again.')
        
            # Redirect back to the password reset page or render the template again
            return render(request, 'digiApp/security/password_reset.html')
        
    return render(request, 'digiApp/security/password_reset.html')





from django.views import View
from django.core.mail import send_mail
from django.shortcuts import render, redirect
from django.contrib import messages
from django.utils.http import urlsafe_base64_decode
from django.utils.encoding import force_str
from django.contrib.auth.tokens import default_token_generator
from django.urls import reverse_lazy
from .models import User  

class CustomPasswordResetConfirmView(View):
    template_name = 'digiApp/security/password_reset_confirm.html'

    def get(self, request, uidb64, token):
        try:
            # Decode user ID from the URL
            uid = force_str(urlsafe_base64_decode(uidb64))
            user = User.objects.get(pk=uid)
        except (TypeError, ValueError, OverflowError, User.DoesNotExist):
            user = None

        # Check if the token is valid
        if user and default_token_generator.check_token(user, token):
            return render(request, self.template_name, {'valid_link': True, 'uidb64': uidb64, 'token': token})
        else:
            messages.error(request, 'The password reset link is invalid or has expired.')
            return render(request, self.template_name, {'valid_link': False})

    def post(self, request, uidb64, token):
        try:
            # Decode user ID from the URL
            uid = force_str(urlsafe_base64_decode(uidb64))
            user = User.objects.get(pk=uid)
        except (TypeError, ValueError, OverflowError, User.DoesNotExist):
            user = None

        # Check if the token is valid
        if user and default_token_generator.check_token(user, token):
            # Get the new password from the form data
            new_password = request.POST.get('new_password1')
            confirm_password = request.POST.get('new_password2')

            # Check if the passwords match
            if new_password and new_password == confirm_password:
                user.set_password(new_password)
                user.save()

                # HTML email content
                html_message = f'''<html>
                <head>
                    <style>
                        body {{
                            font-family: Arial, sans-serif;
                            color: #333;
                            background-color: #f4f4f4;
                            padding: 20px;
                        }}
                        .email-container {{
                            max-width: 600px;
                            margin: 0 auto;
                            padding: 20px;
                            background-color: #fff;
                            border-radius: 8px;
                            box-shadow: 0 4px 8px rgba(0, 2, 2, 0.1);
                        }}
                        .email-header {{
                            text-align: center;
                            padding-bottom: 20px;
                        }}
                        .email-header h1 {{
                            color: #0073e6;
                        }}
                        .email-body {{
                            font-size: 12px;
                            line-height: 1.2;
                        }}
                        .cta-button {{
                            display: inline-block;
                            padding: 10px 20px;
                            background-color: #0073e6;
                            color: white;
                            text-decoration: none;
                            border-radius: 5px;
                            margin-top: 20px;
                            font-weight: bold;
                        }}
                        .cta-button:hover {{
                            background-color: #005bb5;
                        }}
                        .footer {{
                            font-size: 12px;
                            text-align: center;
                            margin-top: 20px;
                            color: #777;
                        }}
                    </style>
                </head>
                <body>
                    <div class="email-container">
                        <div class="email-header">
                            <h1>Your Password Has Been Reset Successfully!</h1>
                        </div>
                        <div class="email-body">
                            <p>Hello <strong>{user.username}</strong>,</p>
                            <p>We are writing to inform you that your password has been successfully reset.</p>
                            <p>If you requested this password reset, your new password is:</p>
                            <p><strong>{new_password}</strong></p>
                            <p>Please ensure that you store your password securely. If you did not request this password reset or if you have any concerns, please contact our support team immediately.</p>
                            <p>If you're ready, you can <a href="https://yourwebsite.com/login" class="cta-button">Log in to your account</a> and start using your account with your new password.</p>
                        </div>
                        <div class="footer">
                            <p>Thank you,</p>
                            <p>The Quality Grade Digitals Team</p>
                            <p>&copy; {datetime.now().year} Quality Grade Digitals. All rights reserved.</p>
                        </div>
                    </div>
                </body>
                </html>
                '''

                # Send the HTML email with a custom "from" name
                send_mail(
                    'Your Password Has Been Reset',
                    '',  # No plain text body as we're sending HTML content
                    'Quality Grade Digitals <no-reply@qualitygrade.com>',  # Custom sender name
                    [user.email],
                    fail_silently=False,
                    html_message=html_message  # HTML content
                )

                # Redirect to the password reset done page
                return redirect(reverse_lazy('password_reset_complete'))
            else:
                # If passwords don't match
                messages.error(request, 'Passwords do not match. Please try again.')
                return render(request, self.template_name, {'valid_link': True, 'uidb64': uidb64, 'token': token})

        else:
            # If the token is invalid or expired
            messages.error(request, 'The password reset link is invalid or has expired.')
            return render(request, self.template_name, {'valid_link': False})
