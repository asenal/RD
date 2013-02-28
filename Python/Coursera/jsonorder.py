#!/usr/bin/python2.7
import json,os,sys,re
from getopt import getopt
opts,args=getopt(sys.argv[1:],'hi:o:')
for (key,value) in opts:
    if key == '-i':
        input=value
        print 'input is %s' % input
    if key == '-o':
        output=value
        print 'input is %s' % output
    if key == '-h':
        msg='''python jsonorder.py -i PGM.json -o course.list '''
        print msg

def get_course_index(name):
    pattern=re.compile('^(C\d+)-')
    P=pattern.match(name)
    tmp=P.group(1)
    return int(re.sub('^C','',tmp))

with open(input,'r') as jsonfile:
    records=json.load(jsonfile)
    names=records.keys()

names.sort(cmp=lambda x,y:cmp(get_course_index(x),get_course_index(y)))

with open(output,'w') as f:
    for i in names:
        f.write(i)
        f.write('\n')
