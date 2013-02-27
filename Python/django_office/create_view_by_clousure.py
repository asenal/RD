#!/usr/bin/python2.7
# Create your views here.  
# refer:[http://proton.iteye.com/blog/764283]
from django.http import HttpResponse  
import sys  
  
def gen(fn):  
    def _f(request):  
        return HttpResponse("%s page!" % fn)  
    _f.func_name = fn  
    return _f  
  
l = [  
    'index',  
    'purchase',  
    'message',  
    'setting',  
    'message_post',  
    'message_anonpost',  
    'setting_update',  
    'ajax_history',  
    'ajax_purchase',  
    'ajax_message_setviewed'  
]  
  
for i in l:  
#    sys.modules[__name__].__dict__[i] = gen(i) 
    
