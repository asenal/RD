#!/usr/bin/python2.7
# generate a course.json file containing all course information,rename all downloaded videos. 
import sys,os,re,json
from getopt import getopt
def main():
    option,argv=getopt(sys.args[1:])
    
# step1:get course information using 'getcourse.py',store to course.json


# step2:go through course subdirectories rename each item


