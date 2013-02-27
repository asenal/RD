from django.conf.urls.defaults import patterns, include, url

# Uncomment the next two lines to enable the admin:
from django.contrib import admin
admin.autodiscover()

# this is asenal's apps import
from caoliu.views import current_datetime

urlpatterns = patterns('',
    # Examples:
    # url(r'^$', 'caoliu.views.home', name='home'),
    # url(r'^caoliu/', include('caoliu.foo.urls')),

    # Uncomment the admin/doc line below to enable admin documentation:
    url(r'^admin/doc/', include('django.contrib.admindocs.urls')),

    # Uncomment the next line to enable the admin:
    url(r'^admin/', include(admin.site.urls)),

    # 1st test:current time
    url(r'^current_datetime/$',include(current_datetime)),
)
