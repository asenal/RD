#!/usr/bin/python
i=0
while i <= 3:
    print(i)
    i+=1
hash={'name':'henry','age':45,'team':'asenal'}
print(hash)
names=['henry','asenal','mario']
ages=[34,39,42,50]
zips=list(zip(names,ages))


# ---OO
class Fibs:
    def __init__(self):
        self.a=0
        self.b=1
    def next(self):
        self.a,self.b=self.b,self.a+self.b
        return self.a
    def __iter__(self):
        return self

b=Fibs()
for i in b:
    if i>1000:
        print(i)
        break
