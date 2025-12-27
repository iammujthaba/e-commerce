from . import views
from django.urls import path

app_name = 'auth_app'
urlpatterns = [
    path('login/',views.login,name='login'),
    path('logout/',views.logout,name='logout'),
    path('register/',views.register,name='register'),
    path('account-info/', views.account_info, name='account_info'),
    path('loginOrRegister/',views.loginOrRegister,name='loginOrRegister'),
    path('superuser_password/', views.superuser_password, name='superuser_password'),
]