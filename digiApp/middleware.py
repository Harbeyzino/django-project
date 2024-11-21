from django.shortcuts import redirect
from django.conf import settings

class RoleBasedAccessMiddleware:
    """
    Middleware to handle access control based on user roles (admin or regular user)
    and enforce authentication for accessing specific views.
    """

    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        # Check if the user is authenticated
        if request.user.is_authenticated:
            # Handle admin and regular user redirection
            if request.path.startswith('/admin-portal/') and not request.user.is_staff:
                # If a regular user tries to access an admin page, redirect them to the home page
                return redirect('app.homepg')
            elif request.path.startswith('/product/') and request.user.is_staff:
                # If an admin user tries to access a regular user page, redirect them to the admin home page
                return redirect('app.adminHome')

        else:
            # If the user is not authenticated and trying to access protected pages
            protected_paths = [
                '/admin-portal/',  # Add all paths that require authentication
                '/product/',
                '/create-product/'
            ]
            if any(request.path.startswith(path) for path in protected_paths):
                return redirect(settings.LOGIN_URL)

        # Continue processing the request
        response = self.get_response(request)
        return response
