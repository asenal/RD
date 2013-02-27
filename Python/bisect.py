#!/usr/bin/python
from bisect import bisect
grades = "FEDCBA"
def grade(total):
    return grades[bisect(breakpoints, total)]

breakpoints = [30, 44, 66, 75, 85]
map(grade, [33, 99, 77, 44, 12, 88])
