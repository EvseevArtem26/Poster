from rest_framework import serializers
from .models import *


class UserSerializer(serializers.ModelSerializer):

    class Meta:
        model = User
        fields = ['username', 'email', 'userpic']


class PostSerializer(serializers.ModelSerializer):

    class Meta:
        model = Post
        fields = ['title', 'text', 'media', 'publication_time', 'author', 'platforms']


class PlatformSerializer(serializers.ModelSerializer):

    class Meta:
        model = Platform
        fields = ['login', 'password', 'email', 'phone_number', 'platform', 'user']


class PlatformPostSerializer(serializers.ModelSerializer):

    class Meta:
        model = PlatformPost
        fields = ['post', 'title', 'platform', 'text', 'media', 'publication_time']