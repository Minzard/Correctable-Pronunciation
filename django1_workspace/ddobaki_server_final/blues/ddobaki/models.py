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

class word_list1(models.Model):
	word = models.CharField(max_length = 20)

class word_list2(models.Model):
    word = models.CharField(max_length = 20)

class word_list3(models.Model):
    word = models.CharField(max_length = 20)

class word_list4(models.Model):
    word1 = models.CharField(max_length = 20)
    word2 = models.CharField(max_length = 20)
