#!/usr/bin/python
import sys,getopt
from pprint import pprint
opts,args=getopt.getopt(sys.argv[1:],'c:u:k')
#opts,args=getopt.getopt(sys.argv[1:],["url=","course="])
pprint (opts)
pprint (args)

#def main():
#    try:
#        opts, args = getopt.getopt(sys.argv[1:], "ho:v", ["help", "output="])
#    except getopt.GetoptError, err:
#        # print help information and exit:
#        print str(err) # will print something like "option -a not recognized"
#        usage()
#        sys.exit(2)
#    output = None
#    verbose = False
#    for o, a in opts:
#        if o == "-v":
#            verbose = True
#        elif o in ("-h", "--help"):
#            usage()
#            sys.exit()
#        elif o in ("-o", "--output"):
#            output = a
#        else:
#            assert False, "unhandled option"
