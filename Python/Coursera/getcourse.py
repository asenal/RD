#!/usr/bin/python2.7
# NOTE:this is a simple script to download lecture material from 'class.coursera.org' which is a marvelous opencourse site.
# this script downloads all the videos at once,my first intention to write this is to make a backup of the 'review' videos.It's highly 
# recommended to follow the course's schedule week by week hence you can learn more.
# CONTACT:qiulin.work@gmail.com 
# DATE   :2012.09.13

import urllib,urllib2,re,os,sys,getopt,json
from BeautifulSoup import BeautifulSoup
from HTMLParser import HTMLParser

class web(HTMLParser):
    sub_link=False
    new_unit=False
    def __init__(self):
        HTMLParser.__init__(self)
        self.unit_name=''
        self.src_href=''
        self.src_dict={}
        self.count=0
    def handle_starttag(self,tag,attrs):
        attrs=dict(attrs)
        if tag=='h3' and 'class' in attrs:
            self.new_unit=True
        elif tag=='a' and 'data-lecture-view-link' in attrs:
            self.count+=1
            self.sub_link=True
            self.src_href=attrs['data-lecture-view-link']
    def handle_data(self,data):
        pattern=r'(Week|Part)(\s)([\d])+'
        data=re.sub(pattern,r'\1\3',data)
        pattern=r'[():,.!?\-~/]'
        data=re.sub(pattern,'',data)
        sep='_'
        tmp_title=sep.join(data.split())
        if self.new_unit:
            self.unit_name=tmp_title
        elif self.sub_link:
            video_name='C'+str(self.count)+'-'+tmp_title
            self.src_dict[video_name]={'href':self.src_href,'unit':self.unit_name}
    def handle_endtag(self,tag):
        self.new_unit=False
        self.sub_link=False
    def close(self):
        print "html parser close"

#--------defination of download_video---------
def download_video(video_name,video_info):
    """download video and subtitle into proper subdirectory;
    video_name is a string object,video_info is a dict like {'unit':week3,'src_href':'http...'}"""
    page=urllib.urlopen(video_info['href']).read()
    soup=BeautifulSoup(page)
    #download mp4
    try:
        soup_tag_list=soup.findAll('source') # return a list of soup tag objects
        video_link=soup_tag_list[0]['src'] # a soup-tag object can be visited like a dictionary.
        os.system("wget -c %s -O %s.mp4" % (video_link,video_name))
    except:
        print "link expired"
    else:
        os.system("mv %s.mp4 %s" % (video_name,video_info['unit']))
    #download subtitle
    try:
        subtitle_link=soup('track')[0]['src']  # soup('track') :not soup['track']
        os.system("wget -c %s -O %s.srt" % (subtitle_link,video_name))
    except:
        print "link expired"
    else:
        os.system("mv %s.srt  %s" % (video_name,video_info['unit']))

#--------main-----------
opts=getopt.getopt(sys.argv[1:],['course=','url='])
course=
url=
#course='Model_Thinking'
#mainpage=urllib.urlopen('https://class.coursera.org/modelthinking/lecture/preview/index').read() 
#parser=web()
#parser.feed(mainpage)
#dict_bak=parser.src_dict
#parser.close()
### store all video_information to a 'json' file
##with open("%s.json" % course,'w') as f:
##    json.dump(dict_bak,f,indent=3)
##f.close()
#
#try:
#    os.stat(course)
#except (OSError),e:
#    print e
#    print "I'm gonna make it" 
#    os.mkdir(course)
#os.chdir(course)
#for video_name,video_info in dict_bak.items():
#    # check if subdirectory exists
#    try:
#        os.stat(video_info['unit'])
#    except (OSError),e:
#        print e
#        print "I'm gonna make it"
#        os.mkdir(video_info['unit'])
#    try:
#        os.stat("./%s/%s.mp4" % (video_info['unit'],video_name))
#    except:
#        print "download %s" % video_name
#        download_video(video_name,video_info)
#        continue
#    else:
#        print "%s already exists,skip item" % video_name
#os.chdir('../')

###hyperlinks=[i for i in parser.sub_links if 'lecture_id' in i]
###hyperlinks.sort(cmp=lambda x,y:cmp(int(re.search("lecture_id=(\d+)",x).groups()[0]),int(re.search("lecture_id=(\d+)",y).groups()[0])))
##print soup.prettify()
##hyperlinks.sort(cmp=lambda x,y:cmp(int(re.search("lecture_id=(\d+)",x).groups()[0]),int(re.search("lecture_id=(\d+)",y).groups()[0])))
