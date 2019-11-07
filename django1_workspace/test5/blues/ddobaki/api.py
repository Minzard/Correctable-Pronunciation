from .models import get_ddobaki
from rest_framework import serializers, viewsets
from . import Korean_handler_all
from django.http import HttpResponse, JsonResponse
import json


class get_ddobaki_Serializer(serializers.ModelSerializer):
    divided_stt = serializers.SerializerMethodField()
    color = serializers.SerializerMethodField()

    class Meta:
        
        model = get_ddobaki
        fields = ['user', 'label', 'stt', 'current_time', 'divided_stt' ,'color']
#        dtt = Meta.fields[2]
#        dtt = Korean_handler.convert(dtt)
#        print(dtt)
#
    def get_divided_stt(self, obj):
        dtt = obj.stt
        dtt = Korean_handler_all.divide(dtt)
        dtt = "".join(dtt.split())
        return (dtt)

    def get_color(self, obj):
        lab = obj.label
        dtt = obj.stt
        dtt = "".join(dtt.split())
        c_color = Korean_handler_all.convert(lab, dtt)
        return (c_color)

#        def index(request):
#            newData = {
#                'user' : 'user',
#                'label' : 'label',
#                'stt' : 'stt',
#                'current_time' : 'current_time',
#                'divided_stt': 'dtt'
#            }
#            return JsonResponse(newData)



class get_ddobaki_ViewSet(viewsets.ModelViewSet):
    queryset = get_ddobaki.objects.all()
    serializer_class = get_ddobaki_Serializer
