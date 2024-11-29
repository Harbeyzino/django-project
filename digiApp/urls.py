from django.urls import path
from . import views
from django.conf import settings  
from django.conf.urls.static import static 
from django.contrib.auth import views as auth_views
from .views import CustomPasswordResetCompleteView


urlpatterns = [
    path('', views.homepg, name='app.home' ),
    path('product/', views.products, name='app.view_products' ),

    
    path('create_product/', views.createProduct, name='app.create_product' ),
    path('store_product/', views.storeProduct, name='app.store_product' ),
    path('edit_product/<int:id>', views.editProduct, name='app.edit_product' ),
    path('update_product/<int:id>', views.updateProduct, name='app.update_product' ),
    path('destroy_product/<int:id>', views.destroyProduct, name='app.destroy_product' ),
    path('profile/edit/', views.edit_profile, name='edit_profile'),
    path("profile/", views.profile_page, name="profile_page"),

        ###################### Password Reset ###############
    path('password-reset/', views.custom_password_reset, name='password_reset'),
    
    path('password-reset/done/', 
         auth_views.PasswordResetDoneView.as_view(template_name='digiApp/security/password_reset_done.html'), 
         name='password_reset_done'),

    path(
        'reset/<uidb64>/<token>/',
        auth_views.PasswordResetConfirmView.as_view(template_name='digiApp/security/password_reset_confirm.html'),
        name='password_reset_confirm'
    ),

    path('reset/done/', CustomPasswordResetCompleteView.as_view(), name='password_reset_complete'),

    ## Security Path 

    path('security/sign_up/', views.signUp, name='security.signup'),
    path('security/register/', views.register, name='security.register'),
    path('security/sign_in/', views.signIn, name='security.sign_in'),
    path('security/login/', views.logIn, name='security.login'),
    path('security/singout/', views.signOut, name='security.signout'),
    
    path('no_permission/', views.no_permission, name='app.no_permission'),

    ## Path for myadmin
    path('myadmin_portal/', views.adminHome, name="app.admin")


    
  
]

if settings.DEBUG:  
    urlpatterns += static(settings.MEDIA_URL,document_root=settings.MEDIA_ROOT)