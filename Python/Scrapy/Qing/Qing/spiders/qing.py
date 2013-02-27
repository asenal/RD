from scrapy import log # This module is useful for printing out debug information
from scrapy.spider import BaseSpider
from scrapy.selector import HtmlXPathSelector
from scrapy.http import Request

class Qing(BaseSpider):
    name = 'meilv'
    allowed_domains = ['http://']
    start_urls = [
     'file:///home/asenal/scrapy_www/2819266755.html'
    ]

    def parse(self, response):
        self.log('Let\'s tango! Start from %s just arrived!' % response.url)




class MySpider(BaseSpider):
    name = 'example.com'
    allowed_domains = ['example.com']
    start_urls = [
        'http://www.example.com/1.html',
        'http://www.example.com/2.html',
        'http://www.example.com/3.html',
    ]

    def parse(self, response):
        hxs = HtmlXPathSelector(response)
        for h3 in hxs.select('//h3').extract():
            yield MyItem(title=h3)

        for url in hxs.select('//a/@href').extract():
            yield Request(url, callback=self.parse)        
