"""blues URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/2.1/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
#from django.contrib import admin
#from django.urls import path


from rest_framework import routers
from rest_framework_swagger.views import get_swagger_view
from django.contrib import admin
from django.urls import path, include
#from ddobaki.models import get_ddobaki


import ddobaki.api

app_name = 'ddobaki'


router = routers.DefaultRouter()
router.register('ddobakis', ddobaki.api.get_ddobaki_ViewSet)
router.register('wordlist1', ddobaki.api.word_list1_ViewSet)
router.register('wordlist2', ddobaki.api.word_list2_ViewSet)
router.register('wordlist3', ddobaki.api.word_list3_ViewSet)
router.register('wordlist4', ddobaki.api.word_list4_ViewSet)


#urlpatterns = [
#    path('admin/', admin.site.urls),
#]

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/doc', get_swagger_view(title='Rest API Document')),
    path('api/vi/', include((router.urls, 'ddobaki'), namespace='api')),
               #path('insert/(?P<divided_stt>.+); (?P<accuracy>.+);(?P<color>.*)',get_ddobaki.Insert_get_ddobaki)
]

