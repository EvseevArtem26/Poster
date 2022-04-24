from .serializers import *
from rest_framework import generics
from rest_framework import authentication
from rest_framework.parsers import MultiPartParser, FormParser, JSONParser
from rest_framework.permissions import IsAuthenticated
from rest_framework.viewsets import ModelViewSet


# User viewset

class UserViewSet(ModelViewSet):
	serializer_class = UserSerializer
	authentication_classes = (authentication.TokenAuthentication,)
	permission_classes = (IsAuthenticated,)
	parser_classes = (MultiPartParser, FormParser, JSONParser)

	def get_queryset(self):
		return User.objects.all()


# Post viewset

class PostViewSet(ModelViewSet):
	serializer_class = PostSerializer
	parser_classes = [MultiPartParser, FormParser]
	authentication_classes = [authentication.TokenAuthentication]
	permission_classes = [IsAuthenticated]

	def get_queryset(self):
		queryset = Post.objects.all()
		params = self.request.query_params
		user = params.get('username', None)
		status = params.get('status', None)
		if user:
			queryset = queryset.filter(author__username=user)
		if status:
			queryset = queryset.filter(status=status)
		return queryset


# Platform viewset

class PlatformViewSet(ModelViewSet):
	serializer_class = PlatformSerializer
	authentication_classes = [authentication.TokenAuthentication]
	permission_classes = [IsAuthenticated]

	def get_queryset(self):
		queryset = Platform.objects.all()
		params = self.request.query_params
		user = params.get('username', None)
		if user:
			queryset = queryset.filter(user__username=user)
		return queryset


# PlatformPost viewset

class PlatformPostViewSet(ModelViewSet):
	serializer_class = PlatformPostSerializer
	parser_classes = [MultiPartParser, FormParser]
	queryset = PlatformPost.objects.all()
	authentication_classes = [authentication.TokenAuthentication]
	permission_classes = [IsAuthenticated]

	def get_queryset(self):
		queryset = PlatformPost.objects.all()
		params = self.request.query_params
		user = params.get('username', None)
		if user:
			queryset = PlatformPost.objects.filter(platform__user__username=user)
		return queryset