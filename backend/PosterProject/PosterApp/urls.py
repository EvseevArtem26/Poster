from django.urls import path
from .views import *

app_name = 'PosterApp'

#TODO: объединить эндпоинты
urlpatterns = [
    path('users/', UserListCreateAPIView.as_view()),
    path('users/<int:pk>/', UserRetrieveUpdateDestroyAPIView.as_view()),
    path('posts/', PostListCreateAPIView.as_view()),
    path('posts/<int:pk>/', PostRetrieveDestroyAPIView.as_view()),
    path('posts/<int:pk>/update', PostUpdateAPIView.as_view()),
    path('platforms/', PlatformListCreateAPIView.as_view()),
    path('platforms/<int:pk>/', PlatformRetrieveDestroyAPIView.as_view()),
    path('platforms/<int:pk>/update', PlatformUpdateAPIView.as_view()),
    path('platform-posts/', PlatformPostListCreateAPIView.as_view()),
    path('platform-posts/<int:pk>', PlatformPostRetrieveUpdateDestroyAPIView.as_view())
]