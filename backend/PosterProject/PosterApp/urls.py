from django.urls import path
from .views import *

app_name = 'PosterApp'

urlpatterns = [
    path('users/', UserListAPIView.as_view()),
    path('users/create', UserCreateAPIView.as_view()),
    path('users/<int:id>/', UserRetrieveAPIView.as_view()),
    path('users/<int:id>/delete/', UserDestroyAPIView.as_view()),
    path('posts/', PostListAPIView.as_view()),
]