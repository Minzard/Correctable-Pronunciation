#from django.db import models
#from . import postmodel
#
#class get_ddobaki(models.Model):
#    value = models.CharField(postmodel, max_length=200)
#    user = models.CharField(max_length=100)
#    label = models.CharField(max_length=50)
#    stt = models.CharField(max_length=50)
#    current_time = models.DateTimeField(auto_now_add=True)
# Create your models here.

from django.db import models

class get_ddobaki(models.Model):
    user = models.CharField(max_length=100)
    label = models.CharField(max_length=50)
    stt = models.CharField(max_length=50)
    current_time = models.DateTimeField(auto_now_add=True)
    divided_stt = models.CharField(max_length=100, blank=True)
    accuracy = models.IntegerField(default=0)
    color = models.CharField(max_length=100, null=True)

