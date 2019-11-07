from django.db import models

class get_ddobaki(models.Model):
    user = models.CharField(max_length=100)
    label = models.CharField(max_length=50)
    stt = models.CharField(max_length=50)

class post_ddobaki(models.Model):
    divided_stt = models.CharField(max_length=100)
    color = models.BooleanField(default=True)

# Create your models here.
