#!/usr/bin/python2.7
import json,os,sys
from getopt import getopt
opts,args=getopt(sys.argv[1:],'i:o:')
for (key,value) in opts:
    if key == '-i':
        input=value
        print 'input is %s' % input
    if key == '-o':
        output=value
        print 'input is %s' % output

print args

#with open('')
