from email.policy import default
from platform import platform
from django.db import models
from django.contrib.auth.models import AbstractUser
from django.conf import settings
# Create your models here.


def user_dir_path(instance, filename):
	return f"users/{instance.username}/{filename}"

def post_dir_path(instance,filename):
	user = instance.author
	return f"users/{user.username}/posts/{instance.title}/{filename}"

def platform_post_dir_path(instance,filename):
	post = instance.post
	user = post.author
	platform = instance.platform
	title = instance.title if instance.title else post.title
	return f"users/{user.username}/posts/{platform.platform}/{title}/{filename}"

class User(AbstractUser):
	username = models.CharField(max_length=45, unique=True)
	email = models.EmailField(blank=False)
	userpic = models.ImageField(upload_to=user_dir_path, default='users/default-user-image.png')
	USERNAME_FIELD = 'username'
	REQUIRED_FIELDS = ['email']

	def __str__(self):
		return self.username


class Post(models.Model):
	text = models.TextField()
	media = models.FileField(null=True, blank=True, upload_to=post_dir_path)
	#TODO: Реализовать возможность добавления нескольких файлов
	publication_time = models.DateTimeField(null=True, blank=False)
	author = models.ForeignKey(to=settings.AUTH_USER_MODEL, related_name='author', on_delete=models.CASCADE)
	#TODO: Создать дополнительное поле/таблицу для разделения опубликованных постов и черновиков
	platforms = models.ManyToManyField(to='Platform', through='PlatformPost')
	STATUS_CHOICES = (
		('waiting', 'Waiting'),
		('draft', 'Draft'),
		('published', 'Published'),
		('delayed', 'Delayed'),
	)
	status = models.CharField(max_length=10, choices=STATUS_CHOICES, default='draft')


class Platform(models.Model):
	login = models.CharField(max_length=60)
	password = models.CharField(max_length=45)
	email = models.EmailField()
	phone_number = models.CharField(max_length=15)
	PLATFORM_CHOICES = [
		('VK', 'Vkontakte'),
		('OK', 'Odnoklassniki'),
		('FB', 'Facebook'),
		('TW', 'Twitter'),
		('IG', 'Instagram'),
		('TT', 'TikTok'),
		('YT', 'Youtube'),
		('TG', 'Telegram')
	]
	platform = models.CharField(max_length=2, choices=PLATFORM_CHOICES)
	user = models.ForeignKey(to=settings.AUTH_USER_MODEL, related_name='user', on_delete=models.CASCADE)
	

	def __str__(self):
		return f"{self.platform}-{self.login}"


class PlatformPost(models.Model):
	post = models.ForeignKey(to=Post, on_delete=models.CASCADE)
	platform = models.ForeignKey(to=Platform, on_delete=models.CASCADE)
	text = models.TextField(null=True)
	media = models.FileField(null=True, blank=True, upload_to=platform_post_dir_path)
	publication_time = models.DateTimeField(null=True)
	STATUS_CHOICES = (
		('waiting', 'Waiting'),
		('draft', 'Draft'),
		('published', 'Published'),
		('delayed', 'Delayed'),
	)
	status = models.CharField(max_length=10, choices=STATUS_CHOICES, default='draft')
