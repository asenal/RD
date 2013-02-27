#!/usr/bin/python2.7
import json,sys,os
from getopt import getopt
opts,args=getopt(sys.argv[1:],'f:o:')
for key,value in opts:
    if key == '-f':
        print 'json file is %s' % value
        J=value
    if key == '-o':
        print 'output is %s' % value
        out=value

J='PGM.json'
with open(J,'r') as f:
    records=json.load(f)
keys=records.keys()



    
