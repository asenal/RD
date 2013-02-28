import itertools

# list chain
L1=[1,2,3]
L2=['a','b','c','d']
for item in itertools.chain(L1,L2):
    print item

# count :endless iter count
i=0
for item in itertools.count(-5):
    if i>10:break
    print item
    i+=1

# cycle : endless cycle
i=0
for item in itertools.cycle(L2):
    if i<10:
        i+=1
        print item
    else: break

# ifilter : ifilter(fun,iterator),same as filter,but return a iterator
I=itertools.ifilter(lambda x:x>5 , range(10))
print list(I)

# imap: same as map,return an iterator
I=itertools.imap(lambda x:x+5 , range(10))
print list(I)

# izip : same as zip,return a iterator

# repeat
for item in itertools.repeat(L1,3):
    print item
