from .serializers import *
from rest_framework import generics
from rest_framework.response import Response
from rest_framework import authentication

# User views

class UserListAPIView(generics.ListAPIView):
    serializer_class = UserSerializer

    def get_queryset(self):
        return User.objects.all()


class UserRetrieveAPIView(generics.RetrieveAPIView):
	serializer_class = UserSerializer
	queryset = User.objects.all()
	authentication_classes = [authentication.TokenAuthentication]

	def get(self, request, id):
		user = User.objects.get(pk=id)
		serializer = UserSerializer(user)
		return Response(serializer.data)


class UserCreateAPIView(generics.CreateAPIView):
	serializer_class = UserSerializer
	queryset = User.objects.all()


class UserUpdateAPIView(generics.UpdateAPIView):
	serializer_class = UserSerializer
	queryset = User.objects.all()


class UserDestroyAPIView(generics.DestroyAPIView):
	serializer_class = UserSerializer
	queryset = User.objects.all()


# Post views

class PostListAPIView(generics.ListAPIView):
    serializer_class = PostSerializer

    def get_queryset(self):
        return Post.objects.all()


class PostRetrieveAPIView(generics.RetrieveAPIView):
	serializer_class = PostSerializer
	queryset = Post.objects.all()

	def get(self, request, id):
		post = Post.objects.get(pk=id)
		serializer = PostSerializer(post)
		return Response(serializer.data)


class PostCreateAPIView(generics.CreateAPIView):
	serializer_class = PostSerializer


class PostUpdateAPIView(generics.UpdateAPIView):
	serializer_class = PostSerializer


class PostDestroyAPIView(generics.DestroyAPIView):
	serializer_class = PostSerializer


# Platform views

class PlatformListAPIView(generics.ListAPIView):
    serializer_class = PlatformSerializer

    def get_queryset(self):
        return Platform.objects.all()


class PlatformRetrieveAPIView(generics.RetrieveAPIView):
	serializer_class = PlatformSerializer
	queryset = Platform.objects.all()
	
	def get(self, request, id):
		post = Platform.objects.get(pk=id)
		serializer = PlatformSerializer(post)
		return Response(serializer.data)


class PlatformCreateAPIView(generics.CreateAPIView):
	serializer_class = PlatformSerializer


class PlatformUpdateAPIView(generics.UpdateAPIView):
	serializer_class = PlatformSerializer


class PlatformDestroyAPIView(generics.DestroyAPIView):
	serializer_class = PlatformSerializer