from rest_framework import serializers
from .models import *


class UserSerializer(serializers.ModelSerializer):

    class Meta:
        model = User
        fields = ['pk', 'username', 'email', 'userpic']

class PlatformSerializer(serializers.ModelSerializer):

    class Meta:
        model = Platform
        fields = ['pk', 'login', 'password', 'email', 'phone_number', 'platform', 'user']

class PlatformDetailSerializer(serializers.ModelSerializer):
    user = UserSerializer()

    class Meta:
        model = Platform
        fields = ['pk', 'login', 'password', 'email', 'phone_number', 'platform', 'user']


class PostDetailSerializer(serializers.ModelSerializer):
    author = UserSerializer()
    platforms = PlatformSerializer(many=True)

    class Meta:
        model = Post
        fields = ['pk', 'title', 'text', 'media', 'publication_time', 'author', 'platforms']
        

class PostSerializer(serializers.ModelSerializer):
    
    class Meta:
        model = Post
        fields = ['pk', 'title', 'text', 'media', 'publication_time', 'author', 'platforms']

class PlatformPostSerializer(serializers.ModelSerializer):
    platform = PlatformSerializer()
    post = PostSerializer()

    class Meta:
        model = PlatformPost
        fields = ['pk', 'post', 'title', 'platform', 'text', 'media', 'publication_time']

