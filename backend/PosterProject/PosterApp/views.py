from .serializers import *
from rest_framework import generics
from rest_framework import authentication
from rest_framework.parsers import MultiPartParser, FormParser

#  User views

class UserListCreateAPIView(generics.ListCreateAPIView):
	serializer_class = UserSerializer
	parser_classes = [MultiPartParser, FormParser]

	def get_queryset(self):
		return User.objects.all()


class UserRetrieveUpdateDestroyAPIView(generics.RetrieveUpdateDestroyAPIView):
	serializer_class = UserSerializer
	parser_classes = [MultiPartParser, FormParser]
	queryset = User.objects.all()
	authentication_classes = [authentication.TokenAuthentication]


#  Post views

class PostListCreateAPIView(generics.ListCreateAPIView):
	serializer_class = PostSerializer
	parser_classes = [MultiPartParser, FormParser]

	def get_queryset(self):
		return Post.objects.all()


class PostRetrieveUpdateDestroyAPIView(generics.RetrieveUpdateDestroyAPIView):
	serializer_class = PostSerializer
	parser_classes = [MultiPartParser, FormParser]
	queryset = Post.objects.all()


#  Platform views

class PlatformListCreateAPIView(generics.ListCreateAPIView):
    serializer_class = PlatformSerializer

    def get_queryset(self):
        return Platform.objects.all()


class PlatformRetrieveUpdateDestroyAPIView(generics.RetrieveUpdateDestroyAPIView):
	serializer_class = PlatformSerializer
	queryset = Platform.objects.all()


#  PlatformPost views

class PlatformPostListCreateAPIView(generics.ListCreateAPIView):
	serializer_class = PlatformPostSerializer
	parser_classes = [MultiPartParser, FormParser]

	def get_queryset(self):
		return PlatformPost.objects.all()


class PlatformPostRetrieveUpdateDestroyAPIView(generics.RetrieveUpdateDestroyAPIView):
	serializer_class = PlatformPostSerializer
	parser_classes = [MultiPartParser, FormParser]
	queryset = PlatformPost.objects.all()