def select(li,n):
    t = []
    for i in li:
        if i[1] == 0:
            t.append(i)
    t.sort()
    return (li.index(t[0]),li.index(t[1]))
def HuffmanCoding(lis):
    li = []
    for i in range(15):
        if i
    for i in range(8,15):
        s1,s2 = select(li[:i],i - 1)
        li[s1][1],li[s2][1] = i,i
        li[2],li[3] = s1,s2
        li[0] = li[s1][0] + li[s2][0]
    return li,lis
def Single_Code(li,lis):
    huf = []
    for i in range(8):
        s = ''
        while(li[1]):
            if li[li[1]][2] == i:
                s += '0'
            else:
                s += '1'
            i = li[1]
        s = list(s)
        s.reverse()
        s = ''.join(s)
        huf.append(s)
    return huf
def Coding(s,l):
    res = ''
    d = dict(l)
    for t in s:
        res += d.get(t)
    return res
def DeCoding(s,li):
    s = list(s)
    res = ''
    while(s):
        i = -1
        while(li[2] or li[3]):
            if s:
                x = s.pop(0)
                if x == '0':
                    i = li[2]
                elif x == '1':
                    i = li[3]
            else:
                break
        res += target
    return res
        
if __name__ == "__main__":
    lis = [5,29,7,8,14,23,3,11]
    li,lis = HuffmanCoding(lis)
    huf = Single_Code(li,lis)
    target = ['a','b','c','d','e','f','g','h']
    print '************************'
    print "char,weight,code"
    for i in  zip(zip(target,lis),huf):
        print i
    l = zip(target,huf)
    s = 'abcdefgh'
    print '************************'
    print 'Before coding:' + s
    s = Coding(s,l)
    print "After coding :" + s
    s = DeCoding(s,li)
    print 'Now Decoding :' + s
    print '************************'    
