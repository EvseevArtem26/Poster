# Generated by Django 3.1.7 on 2022-02-16 10:35

import PosterApp.models
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('PosterApp', '0004_auto_20220216_1231'),
    ]

    operations = [
        migrations.AddField(
            model_name='post',
            name='media',
            field=models.FileField(null=True, upload_to=PosterApp.models.post_dir_path),
        ),
    ]
