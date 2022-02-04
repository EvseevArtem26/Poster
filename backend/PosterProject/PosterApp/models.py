from django.db import models
from django.contrib.auth.models import AbstractUser
from django.conf import settings
# Create your models here.


class User(AbstractUser):
	username = models.CharField(max_length=45, unique=True)
	email = models.EmailField(blank=False)
	USERNAME_FIELD = 'username'
	REQUIRED_FIELDS = ['email']

	def __str__(self):
		return self.username


class Post(models.model):
	text = models.TextField()
	#TODO: Реализовать сохранение медиафайлов
	#media = models.FileField(null=True)
	#TODO: Реализовать возможность добавления нескольких файлов
	publication_time = models.DateTimeField(null=True, blank=False)
	author = models.ForeignKey(to=settings.AUTH_USER_MODEL, related_name='author', on_delete=models.CASCADE)
	#TODO: Создать дополнительное поле/таблицу для разделения опубликованных постов и черновиков

	def  __str__(self):
		return self.text


class AuthKey(models.Model):
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
	platform = models.CharField(max_length=1, choices=PLATFORM_CHOICES)
	user = models.ForeignKey(to=settings.AUTH_USER_MODEL, related_name='user', on_delete=models.CASCADE)
	
	def __str__(self):
		return f"{self.platform}-{self.login}"


class PlatformPost(models.Model):
	post = models.ForeignKey(to=Post, on_delete=models.CASCADE)
	platform = models.ForeignKey(to=AuthKey, on_delete=models.CASCADE)
	text = models.TextField(null=True)
	media = models.FileField(null=True)
	publication_time = models.DateTimeField(null=True)