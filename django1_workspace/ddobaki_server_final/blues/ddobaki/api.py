#from .models import get_ddobaki
#from rest_framework import serializers, viewsets
#from . import Korean_handler_all, postmodel
#from django.http import HttpResponse, JsonResponse
#import json
#
#
#class post_ddobaki_Serializer(serializers.ModelSerializer):
#    divided_stt = serializers.SerializerMethodField()
#    color = serializers.SerializerMethodField()
#
#    class Meta:
#        model = postmodel
#        fields = ['divided_stt', 'color']
#
#class get_ddobaki_Serializer(serializers.ModelSerializer):
#    value = post_ddobaki_Serializer
#
#    class Meta:
#        model = get_ddobaki
#        fields = ['id', 'user', 'label', 'stt', 'current_time']
##        dtt = Meta.fields[2]
##        dtt = Korean_handler.convert(dtt)
##        print(dtt)
#
#        def get_divided_stt(self, obj):
#            dtt = obj.stt
#            dtt = Korean_handler_all.divide(dtt)
#            dtt = "".join(dtt.split())
#            return (dtt)
#
#        def get_color(self, obj):
#            lab = obj.label
#            dtt = obj.stt
#            dtt = "".join(dtt.split())
#            c_color = Korean_handler_all.convert(lab, dtt)
#            return (c_color)
##        def index(request):
##            newData = {
##                'user' : 'user',
##                'label' : 'label',
##                'stt' : 'stt',
##                'current_time' : 'current_time',
##                'divided_stt': 'dtt'
##            }
##            return JsonResponse(newData)
#
#
#class post_ddobaki_ViewSet(viewsets.ModelViewSet):
#    queryset = postmodel.objects.all()
#    serializer_class = post_ddobaki_Serializer
#
#
#class get_ddobaki_ViewSet(viewsets.ModelViewSet):
#    queryset = get_ddobaki.objects.all()
#    serializer_class = get_ddobaki_Serializer
#
#    def perform_create(self, serializer):
#        serializer.save(value=self.request.value)
from django.utils.six import BytesIO
from rest_framework.parsers import JSONParser
from django.shortcuts import render
from .models import get_ddobaki, word_list1, word_list2, word_list3, word_list4
from rest_framework import serializers, viewsets
from . import Korean_handler_all
from django.http import HttpResponse, JsonResponse
import json


class get_ddobaki_Serializer(serializers.ModelSerializer):
    divided_stt = serializers.SerializerMethodField()
    color = serializers.SerializerMethodField()
    accuracy = serializers.SerializerMethodField()
    
#    stream = BytesIO(json)
#    data = JSONParser().parse(stream)
#
#    serializer = get_ddobaki_Serializer(data=data)
#    serializer.is_valid()
#    serializer.validated_data


    class Meta:
        model = get_ddobaki
        fields = ('id', 'user', 'label', 'stt', 'current_time', 'divided_stt' ,'accuracy', 'color')
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

    def get_accuracy(self, obj):
        lab = obj.label
        dtt = obj.stt
        dtt = "".join(dtt.split())
        c_accuracy = Korean_handler_all.accuracy(lab, dtt)
        return (c_accuracy)

#    def index(request):
#        allData = get_ddobaki.objects.all()
#        context = {'allData' : allData}
#        try :
#            allData = get_ddobaki(divided_stt =request.POST['divided_stt'], color = request.POST['color'],
#                                accuracy = request.POST['accuracy'])
#            allData.save()
#        except :
#            allData = None
#        return render(request, 'elections/index.html', context)

#   **************************************************************************

#    def create(self,validated_data):
#        return get_ddobaki.objects.create(**validated_data)
#
#    def update(self, instance, validated_data):
##        def update(self, request, *args, **kwargs):
##            instance = self.get_object()
##            instance.divided_stt = request.data.get("divided_stt")
##            instance.color = request.data.get("color")
##            instance.accuracy = request.data.get("accuracy")
#        instance.divided_stt = validated_data.get('divided_stt', instance.divided_stt)
#        instance.color = validated_data.get('color', instance.color)
#        instance.accuracy = validated_data.get('accuracy', instance.accuracy)
#        instance.save()
##            serializer = self.get_serializer(instance)
##            serializer.is_valid(raise_exception = True)
##            self.perform_update(serializer)
##
##            return Response(serialzer.data)
#        return instance

#   **************************************************************************

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

class word_list1_Serializer(serializers.ModelSerializer):

    class Meta:
        model = word_list1
        fields = '__all__'

class word_list1_ViewSet(viewsets.ModelViewSet):
    queryset = word_list1.objects.all()
    serializer_class = word_list1_Serializer


class word_list2_Serializer(serializers.ModelSerializer):
    
    class Meta:
        model = word_list2
        fields = '__all__'

class word_list2_ViewSet(viewsets.ModelViewSet):
    queryset = word_list2.objects.all()
    serializer_class = word_list2_Serializer


class word_list3_Serializer(serializers.ModelSerializer):
    
    class Meta:
        model = word_list3
        fields = '__all__'

class word_list3_ViewSet(viewsets.ModelViewSet):
    queryset = word_list3.objects.all()
    serializer_class = word_list3_Serializer



class word_list4_Serializer(serializers.ModelSerializer):
    
    class Meta:
        model = word_list4
        fields = '__all__'

class word_list4_ViewSet(viewsets.ModelViewSet):
    queryset = word_list4.objects.all()
    serializer_class = word_list4_Serializer
