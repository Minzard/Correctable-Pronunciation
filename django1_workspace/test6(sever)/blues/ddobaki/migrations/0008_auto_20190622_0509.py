# Generated by Django 2.1.7 on 2019-06-21 20:09

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('ddobaki', '0007_auto_20190622_0503'),
    ]

    operations = [
        migrations.AlterField(
            model_name='get_ddobaki',
            name='color',
            field=models.CharField(max_length=100, null=True),
        ),
    ]
