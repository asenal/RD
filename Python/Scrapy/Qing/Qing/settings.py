# Scrapy settings for Qing project
#
# For simplicity, this file contains only the most important settings by
# default. All the other settings are documented here:
#
#     http://doc.scrapy.org/topics/settings.html
#

BOT_NAME = 'Qing'
BOT_VERSION = '1.0'

SPIDER_MODULES = ['Qing.spiders']
NEWSPIDER_MODULE = 'Qing.spiders'
USER_AGENT = '%s/%s' % (BOT_NAME, BOT_VERSION)
ITEM_PIPELINES=['scrapy.contrib.pipeline.images.ImagesPipeline']

# pictures storage
IMAGES_STORE='/home/asenal/RD/Python/Scrapy/Qing_pics'
IMAGES_EXPIRES=180  # in day
IMAGES_THUMBS={
    'small':(50,50)
    }
# picture filter by size
IMAGES_MIN_HEIGHT=180
IMAGES_MIN_WIDTH=180

# log & db
LOG_ENABLED=True
LOG_FILE='/home/asenal/RD/Python/Scrapy/Qing.log'
SQLITE_DB='Qing.db'

# download delay
RANDMIZE_DOWNLOAD_DELAY=True
DOWNLOAD_DELAY=0.25

#scheduler_order
SCHEDULER_ORDER='DFO' # depth-first,alternative one is 'BFO' which comsumes more memory but reaches most revelent pages earlier.

# cache
HTTPCACHE_ENABLED=True #Default: False,  Before 0.11, HTTPCACHE_DIR was used to enable cache.
HTTPCACHE_EXPIRATION_SECS=0  #never expired,in seconds
#If zero, cached requests will never expire.  Before 0.11, zero meant cached requests always expire.
HTTPCACHE_DIR='/home/asenal/RD/Python/Scrapy/Qing_httpcache'
HTTPCACHE_IGNORE_HTTP_CODES=[] #Don’t cache response with these HTTP codes.
HTTPCACHE_IGNORE_MISSING=True  # requests not found in the cache will be ignored instead of downloaded.
HTTPCACHE_IGNORE_SCHEMES= ['file']  # Don’t cache responses with these URI schemes.
