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

        
class PostSerializer(serializers.ModelSerializer):
    author = serializers.SlugRelatedField(
        many=False,
        read_only=False,
        slug_field='username',
        queryset = User.objects.all()
    )

    platforms = serializers.SlugRelatedField(
        many=True,
        read_only=True,
        slug_field='platform',
    )

    class Meta:
        model = Post
        fields = "__all__"

class PlatformPostSerializer(serializers.ModelSerializer):

    class Meta:
        model = PlatformPost
        fields = "__all__"


class PlatformPostDetailedSerializer(serializers.ModelSerializer):
    platform = serializers.PrimaryKeyRelatedField(
        many=False,
        read_only=False,
        queryset = Platform.objects.all()
    )

    class Meta:
        model = PlatformPost
        fields = ["pk", "platform", "text", "media", "publication_time", "status"]


class MultiPostSerializer(serializers.ModelSerializer):
    author = serializers.SlugRelatedField(
        many=False,
        read_only=False,
        slug_field='username',
        queryset = User.objects.all()
    )
    platforms = PlatformPostDetailedSerializer(source='platformpost_set', many=True, read_only=False)

    class Meta:
        model = Post
        fields = "__all__"

    def  create(self, validated_data):
        platforms = validated_data.pop('platformpost_set')
        post = Post.objects.create(**validated_data)
        for platform in platforms:
            PlatformPost.objects.create(post=post, **platform)
        return post
    