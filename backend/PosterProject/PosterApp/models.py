from email.policy import default
from platform import platform
from django.db import models
from django.contrib.auth.models import AbstractUser
from django.conf import settings
from .api_calls import send_post
# Create your models here.


def user_dir_path(instance, filename):
	return f"users/{instance.username}/{filename}"





class User(AbstractUser):
	username = models.CharField(max_length=45, unique=True)
	email = models.EmailField(blank=False)
	userpic = models.ImageField(upload_to=user_dir_path, default='users/default-user-image.png')
	USERNAME_FIELD = 'username'
	REQUIRED_FIELDS = ['email']

	def __str__(self):
		return self.username


class Post(models.Model):
	def media_path(instance,filename):
		pk = instance.pk or ''
		user = instance.author
		return fr"users/{user.username}/posts/{pk}/{filename}"


	text = models.TextField()
	media = models.FileField(null=True, blank=True, upload_to=media_path)
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

	def save( self, *args, **kwargs ):
	# Call save first, to create a primary key
		new = self._state.adding
		super().save( *args, **kwargs )

		media = self.media
		if media and new:
			# Create new filename, using primary key and file extension
			oldfile = self.media.name
			last_slash = oldfile.rfind( '/' )
			newfile = self.media_path(oldfile[last_slash:])

			# Create new file and remove old one
			if newfile != oldfile:
				self.media.storage.delete( newfile )
				savedfile = self.media.storage.save( newfile, media )
				self.media.name = savedfile
				self.media.close()
				self.media.storage.delete( oldfile )
				# Save again to keep changes
				kwargs['force_insert'] = False
				kwargs['force_update'] = True
				kwargs['update_fields'] = ['media']
				super().save( *args, **kwargs )
		
		if self.status == 'waiting':
			platform_posts = PlatformPost.objects.filter(post=self)
			print(platform_posts)
			for platform_post in platform_posts:
				if platform_post.status != 'published' and platform_post.status != 'waiting':
					platform_post.status = 'waiting'
					platform_post.save()
			if (PlatformPost.objects.filter(post=self, status="published").count() == platform_posts.count()):
				self.status = 'published'
				super().save(force_update=True, update_fields=['status'])


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
		('TG', 'Telegram'),
		('PT', 'Pinterest'),
	]
	platform = models.CharField(max_length=2, choices=PLATFORM_CHOICES)
	user = models.ForeignKey(to=settings.AUTH_USER_MODEL, related_name='user', on_delete=models.CASCADE)
	

	def __str__(self):
		return f"{self.platform}-{self.login}"


class PlatformPost(models.Model):
	def media_path(instance,filename):
		post = instance.post
		user = post.author
		platform = instance.platform
		return f"users/{user.username}/posts/{post.pk}/{platform.platform}/{filename}"

	post = models.ForeignKey(to=Post, on_delete=models.CASCADE)
	platform = models.ForeignKey(to=Platform, on_delete=models.CASCADE)
	text = models.TextField(null=True)
	media = models.FileField(null=True, blank=True, upload_to=media_path)
	publication_time = models.DateTimeField(null=True)
	STATUS_CHOICES = (
		('waiting', 'Waiting'),
		('draft', 'Draft'),
		('published', 'Published'),
		('delayed', 'Delayed'),
	)
	status = models.CharField(max_length=10, choices=STATUS_CHOICES, default='draft')

	def save(self, *args, **kwargs):
		super().save(*args, **kwargs)
		if (self.status == 'waiting'):
			send_post(self)
