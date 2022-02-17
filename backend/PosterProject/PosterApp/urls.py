from django.urls import path
from .views import *

app_name = 'PosterApp'

#TODO: объединить эндпоинты
urlpatterns = [
    path('users/', UserListCreateAPIView.as_view()),
    path('users/<int:pk>/', UserRetrieveUpdateDestroyAPIView.as_view()),
    path('posts/', PostListCreateAPIView.as_view()),
    path('posts/<int:pk>/', PostRetrieveUpdateDestroyAPIView.as_view()),
    path('platforms/', PlatformListCreateAPIView.as_view()),
    path('platforms/<int:pk>/', PlatformRetrieveUpdateDestroyAPIView.as_view()),
]