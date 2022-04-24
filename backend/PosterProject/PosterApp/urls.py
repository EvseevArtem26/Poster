from django.urls import path
from .views import *

app_name = 'PosterApp'


urlpatterns = [
    path('users/', UserViewSet.as_view({'get': 'list', 'post': 'create'})),
    path('users/<int:pk>/', UserViewSet.as_view({'get': 'retrieve', 'put': 'update', 'delete': 'destroy'})),
    path('posts/', PostViewSet.as_view({'get': 'list', 'post': 'create'})),
    path('posts/<int:pk>/', PostViewSet.as_view({'get': 'retrieve', 'put': 'update', 'delete': 'destroy'})),
    path('platforms/', PlatformViewSet.as_view({'get': 'list', 'post': 'create'})),
    path('platforms/<int:pk>/', PlatformViewSet.as_view({'get': 'retrieve', 'put': 'update', 'delete': 'destroy'})),
    path('platform-posts/', PlatformPostViewSet.as_view({'get': 'list', 'post': 'create'})),
    path('platform-posts/<int:pk>', PlatformPostViewSet.as_view({'get': 'retrieve', 'put': 'update', 'delete': 'destroy'}))
]
