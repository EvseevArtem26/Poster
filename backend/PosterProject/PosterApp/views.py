from .serializers import *
from rest_framework import generics
from rest_framework import authentication
from rest_framework.parsers import MultiPartParser, FormParser, JSONParser
import requests

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
	parser_classes = [MultiPartParser, FormParser, JSONParser]

	def get_queryset(self):
		queryset = Post.objects.all()
		params = self.request.query_params
		user = params.get('username', None)
		if user:
			queryset = Post.objects.filter(author__username=user)
		return queryset

class PostUpdateAPIView(generics.UpdateAPIView):
	serializer_class = PostSerializer
	parser_classes = [MultiPartParser, FormParser]
	queryset = Post.objects.all()


class PostRetrieveDestroyAPIView(generics.RetrieveDestroyAPIView):
	serializer_class = PostDetailSerializer
	parser_classes = [MultiPartParser, FormParser]
	queryset = Post.objects.all()


#  Platform views

class PlatformListCreateAPIView(generics.ListCreateAPIView):
    serializer_class = PlatformSerializer

    def get_queryset(self):
        return Platform.objects.all()


class PlatformUpdateAPIView(generics.UpdateAPIView):
	serializer_class = PlatformSerializer

	def get_queryset(self):
		return Platform.objects.all()


class PlatformRetrieveDestroyAPIView(generics.RetrieveUpdateAPIView):
	serializer_class = PlatformDetailSerializer
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


class PlatformPostPublish(generics.RetrieveAPIView):
	# facebook api link: https://developers.facebook.com/docs/pages/publishing#publish-a-page-post
	# twitter api link: https://developer.twitter.com/apitools/api?endpoint=%2F2%2Ftweets&method=post
	serializer_class = PlatformPostSerializer
	parser_classes = [MultiPartParser, FormParser]
	queryset = PlatformPost.objects.all()

	def get(self, request, id):
		post = PlatformPost.objects.get(id)
		text = post.text or post.post.text
		page_id = post.platform.login # TODO: Получить id страницы пользователя
		page_access_token = page_id #  TODO: Получить токен доступа
		query = f"https://graph.facebook.com/{page_id}/feed?message={text}&access_token={page_access_token}"
		#  request_photo = "https://graph.facebook.com/{page-id}/photos?url={path-to-photo}&access_token={page-access-token}"
		#  request_video = "https://graph.facebook.com/{page-id}/videos"
		response = requests.post(query)
