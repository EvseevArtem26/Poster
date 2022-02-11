from django.urls import path
from .views import *

app_name = 'PosterApp'

urlpatterns = [
    path('users/', UserListAPIView.as_view()),
    path('users/create', UserCreateAPIView.as_view()),
    path('users/<int:id>/', UserRetrieveAPIView.as_view()),
    path('users/<int:pk>/update/', UserUpdateAPIView.as_view()),
    path('users/<int:pk>/delete/', UserDestroyAPIView.as_view()),
    path('posts/', PostListAPIView.as_view()),
    path('posts/create', PostCreateAPIView.as_view()),
    path('posts/<int:id>/', PostRetrieveAPIView.as_view()),
    path('posts/<int:pk>/update/', PostUpdateAPIView.as_view()),
    path('posts/<int:pk>/delete/', PostDestroyAPIView.as_view()),
    path('platforms/', PlatformListAPIView.as_view()),
    path('platforms/create', PlatformCreateAPIView.as_view()),
    path('platforms/<int:id>/', PlatformRetrieveAPIView.as_view()),
    path('platforms/<int:pk>/update/', PlatformUpdateAPIView.as_view()),
    path('platform/<int:pk>/delete/', PlatformDestroyAPIView.as_view()),
]