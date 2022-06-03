from django.core.management.base import BaseCommand, CommandError
from PosterApp.models import Post
from django.utils import timezone

class Command(BaseCommand):

    help = 'Runs delayed publishing job'

    def handle(self, *args, **options):
        posts = Post.objects.filter(status='delayed')
        print("Executing delayed publishing job")
        print("time: ", timezone.now())
        print(f"Found {len(posts)} delayed posts")
        for post in posts:
            print("post ", post.id)
            print("publication time: ",post.publication_time)
            if (post.publication_time <= timezone.now()):
                print("status before:", post.status)
                post.status = 'waiting'
                post.save()
                print("status after:", post.status)

        print("Finished delayed publishing job")