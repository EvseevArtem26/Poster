# Generated by Django 3.1.7 on 2022-02-16 09:12

import PosterApp.models
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('PosterApp', '0002_user_userpic'),
    ]

    operations = [
        migrations.AlterField(
            model_name='user',
            name='userpic',
            field=models.ImageField(default='users/default.jpg', upload_to=PosterApp.models.user_dir_path),
        ),
    ]
