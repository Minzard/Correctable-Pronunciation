from django.db import models

class postmodel(models.Model):
    divided_stt = models.CharField(max_length=100, blank=True)
    color = models.CharField(max_length=100, blank=True)
    accuracy = models.IntegerField(default=0)
