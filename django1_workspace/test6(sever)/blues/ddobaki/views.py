#from django.shortcuts import render
#from rest_framework import viewsets
#from .models import get_ddobaki
#from .serializers import get_ddobaki_Serializer
#
#class get_ddobaki_ViewSet(viewsets.ModelViewSet) :
#    queryset = get_ddobaki.object.all()
#    serialzers_class = get_ddobaki_Serializer

from django.shortcuts import render
from django.http import HttpResponse
from django.views.decorators.csrf import csrf_exempt
from .models import get_ddobaki


#def index(request):
#    allData = get_ddobaki.objects.all()
#    context = {'allData' : allData}
#    try :
#        allData = get_ddobaki(divided_stt =request.POST['divided_stt'], color = request.POST['color'], accuracy = request.POST['accuracy'])
#        allData.save()
#    except :
#        allData = None
#    return render(request, 'ddobaki/index.html', context)

def Insert_get_ddobaki(request, divided_stt, accuracy, color):
    get_ddobaki(divided_stt = divided_stt, accuracy = accuracy, color = color).save()
    return render(request, 'ddobaki/mypage.html')
