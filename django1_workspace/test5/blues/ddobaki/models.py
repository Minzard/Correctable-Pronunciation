from django.db import models

class get_ddobaki(models.Model):
    user = models.CharField(max_length=100)
    label = models.CharField(max_length=50)
    stt = models.CharField(max_length=50)
    current_time = models.DateTimeField(auto_now_add=True)
    divided_stt = models.CharField(max_length=100, blank=True)
    color = models.CharField(max_length=100, blank=True)

# Create your models here.
