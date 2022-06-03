from .serializers import *
from rest_framework import generics
from rest_framework import authentication
from rest_framework.parsers import MultiPartParser, FormParser, JSONParser
from rest_framework.permissions import IsAuthenticated
from rest_framework.viewsets import ModelViewSet
from rest_framework.response import Response
from rest_framework import status
from .api_calls import send_post


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
	parser_classes = [MultiPartParser, FormParser, JSONParser]
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

	def partial_update(self, request, *args, **kwargs):
		instance = self.get_object()
		serializer = PostSerializer(instance, data=request.data, partial=True)
		if serializer.is_valid():
			serializer.save()
			return Response(serializer.data, status=status.HTTP_200_OK)



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
	parser_classes = [MultiPartParser, FormParser, JSONParser]
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

	def create(self, request, *args, **kwargs):
		data = request.data
		serializer = PlatformPostSerializer(data=data)
		if serializer.is_valid():
			serializer.save()
			# send_post(serializer.instance)
			return Response(serializer.data, status=status.HTTP_201_CREATED)
		return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
