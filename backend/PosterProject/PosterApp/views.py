from .serializers import *
from rest_framework import generics
from rest_framework.response import Response

# User views

class UserListAPIView(generics.ListAPIView):
    serializer_class = UserSerializer

    def get_queryset(self):
        return User.objects.all()


class UserRetrieveAPIView(generics.RetrieveAPIView):
	serializer_class = UserSerializer
	queryset = User.objects.all()

	def get(self, request, id):
		user = User.objects.get(pk=id)
		serializer = UserSerializer(user)
		return Response(serializer.data)


class UserCreateAPIView(generics.CreateAPIView):
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