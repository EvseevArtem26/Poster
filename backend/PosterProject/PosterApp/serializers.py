from rest_framework import serializers
from .models import *


class UserSerializer(serializers.ModelSerializer):

    class Meta:
        model = User
        fields = ['pk', 'username', 'email', 'userpic']

class PlatformSerializer(serializers.ModelSerializer):
    user = serializers.SlugRelatedField(
        many=False,
        read_only=False,
        slug_field='username',
        queryset = User.objects.all()
    )

    class Meta:
        model = Platform
        fields = "__all__"

class PlatformDetailSerializer(serializers.ModelSerializer):
    user = UserSerializer()

    class Meta:
        model = Platform
        fields = "__all__"


class PostDetailSerializer(serializers.ModelSerializer):
    author = UserSerializer()
    platforms = PlatformSerializer(many=True)

    class Meta:
        model = Post
        fields = "__all__"
        

class PostSerializer(serializers.ModelSerializer):
    author = serializers.SlugRelatedField(
        many=False,
        read_only=False,
        slug_field='username',
        queryset = User.objects.all()
    )

    class Meta:
        model = Post
        fields = "__all__"

class PlatformPostSerializer(serializers.ModelSerializer):
    platform = PlatformSerializer()
    post = PostSerializer()

    class Meta:
        model = PlatformPost
        fields = "__all__"

