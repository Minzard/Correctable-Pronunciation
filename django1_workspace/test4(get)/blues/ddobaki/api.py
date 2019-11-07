from .models import get_ddobaki
from .models import post_ddobaki
from rest_framework import serializers, viewsets

class get_ddobaki_Serializer(serializers.ModelSerializer):

    class Meta:
        model = get_ddobaki
        fields = '__all__'

class get_ddobaki_ViewSet(viewsets.ModelViewSet):
    queryset = get_ddobaki.objects.all()
    serializer_class = get_ddobaki_Serializer
