from django.test import TestCase
from .models import *

# Create your tests here.

class PlatformTestCase(TestCase):

    @classmethod
    def setUpTestData(cls):
        pass
        user = User.objects.create(
            username='test_user',
            password='test_password',
            email='test_email@mail.ru'
        )
        user.save()
        Platform.objects.create(
            login='Test login', 
            password='Test password', 
            email='Test email', 
            phone_number='1111111111',
            platform='VK',
            user=User.objects.get(id=1),
        ).save()

    def test_str(self):
        platform = Platform.objects.get(id=1)
        self.assertEqual(str(platform), f"{platform.platform}-{platform.login}")

    def test_platform_login(self):
        platform = Platform.objects.get(id=1)
        expected_platform_login = f'{platform.login}'
        self.assertEqual(expected_platform_login, 'Test login')

    def test_platform_password(self):
        platform = Platform.objects.get(id=1)
        expected_platform_password = f'{platform.password}'
        self.assertEqual(expected_platform_password, 'Test password')

    def test_platform_email(self):
        platform = Platform.objects.get(id=1)
        expected_platform_email = f'{platform.email}'
        self.assertEqual(expected_platform_email, 'Test email')

    def test_platform_phone_number(self):
        platform = Platform.objects.get(id=1)
        expected_platform_phone_number = f'{platform.phone_number}'
        self.assertEqual(expected_platform_phone_number, '1111111111')

    def test_platform_platform(self):
        platform = Platform.objects.get(id=1)
        expected_platform_platform = f'{platform.platform}'
        self.assertEqual(expected_platform_platform, 'VK')

    def test_platform_user(self):
        platform = Platform.objects.get(id=1)
        expected_platform_user = f'{platform.user}'
        self.assertEqual(expected_platform_user, 'test_user')


class PlatformPostTestCase(TestCase):

    @classmethod
    def setUpTestData(cls):
        user = User.objects.create(
            username='test_user',
            password='test_password',
            email='test_email@mail.ru'
        )
        user.save()
        post = Post.objects.create(
            text='Test text',
            author=user,
            publication_time='2020-01-01 00:00:00',
            status='Draft',
        )
        post.save()
        platform = Platform.objects.create(
            login='Test login',
            password='Test password',
            email='Test email',
            phone_number='1111111111',
            platform='VK',
            user=user,
        )
        platform.save()
        PlatformPost.objects.create(
            post=post,
            platform=platform,
            text='Test text',
            publication_time='2020-01-01 00:00:00',
            status='Draft'
        ).save()

    def test_platform_post_text(self):
        platform_post = PlatformPost.objects.get(id=1)
        expected_platform_post = f'{platform_post.text}'
        self.assertEqual(expected_platform_post, 'Test text')

    def test_platform_post_author(self):
        platform_post = PlatformPost.objects.get(id=1)
        expected_platform_post_author = f'{platform_post.post.author.username}'
        self.assertEqual(expected_platform_post_author, 'test_user')

    def test_platform_post_publication_time(self):
        platform_post = PlatformPost.objects.get(id=1)
        expected_platform_post_publication_time = f'{platform_post.publication_time}'
        self.assertEqual(expected_platform_post_publication_time, '2020-01-01 00:00:00+00:00')

    def test_platform_post_status(self):
        platform_post = PlatformPost.objects.get(id=1)
        expected_platform_post_status = f'{platform_post.status}'
        self.assertEqual(expected_platform_post_status, 'Draft')

    def test_platform_post_platform(self):
        platform_post = PlatformPost.objects.get(id=1)
        expected_platform_post_platform = f'{platform_post.platform.platform}'
        self.assertEqual(expected_platform_post_platform, 'VK')

    def test_platform_post_media(self):
        platform_post = PlatformPost.objects.get(id=1)
        expected_platform_post_media = f'{platform_post.post.media}'
        self.assertEqual(expected_platform_post_media, '')

    def test_post_contains_platform(self):
        platform_post = PlatformPost.objects.get(id=1)
        self.assertTrue(platform_post.platform in platform_post.post.platforms.all())



class PostTestCase(TestCase):

    @classmethod
    def setUpTestData(cls):
        user = User.objects.create(username='test_user',password='test_password',email='test_email@mail.ru')
        user.save()
        post = Post.objects.create(
            text='Test text', 
            author=user,
            publication_time='2020-01-01 00:00:00',
            status='Draft',
            )
        post.save()

    def test_posts_count(self):
        self.assertEqual(Post.objects.count(), 1)

    def  test_post_content(self):
        post = Post.objects.get(id=1)
        expected_post_text = f'{post.text}'
        self.assertEqual(expected_post_text, 'Test text')

    def test_post_author(self):
        post = Post.objects.get(id=1)
        expected_post_author = f'{post.author}'
        self.assertEqual(expected_post_author, 'test_user')

    def test_post_publication_time(self):
        post = Post.objects.get(id=1)
        expected_post_publication_time = f'{post.publication_time}'
        self.assertEqual(expected_post_publication_time, '2020-01-01 00:00:00+00:00')

    def test_post_status(self):
        post = Post.objects.get(id=1)
        expected_post_status = f'{post.status}'
        self.assertEqual(expected_post_status, 'Draft')

    def test_post_platforms(self):
        post = Post.objects.get(id=1)
        expected_post_platforms = f'{post.platforms}'
        self.assertEqual(expected_post_platforms, 'PosterApp.Platform.None')

    def test_post_media(self):
        post = Post.objects.get(id=1)
        expected_post_media = f'{post.media}'
        self.assertEqual(expected_post_media, '')


