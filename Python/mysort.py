# tuple order
students = [('john', 'A', 15), ('jane', 'B', 12), ('dave', 'B', 10)]  
print sorted(students, key=lambda student : student[2])   # sort by age  

# cmp
print sorted(students, cmp=lambda x,y : cmp(x[2], y[2])) # sort by age  
[('dave', 'B', 10), ('jane', 'B', 12), ('john', 'A', 15)]  

# operator to accelarate: itemgetter(2,3)('asenal')=('e','n')
from operator import itemgetter, attrgetter  
print sorted(students, key=itemgetter(2))  

# multi order
print sorted(students, key=itemgetter(1,2))  # sort by grade then by age  

# dict order : iteritems() returns a generator , generate a item in tuple forms
d = {'data1':3, 'data2':1, 'data3':2, 'data4':4}  
print sorted(d.iteritems(), key=itemgetter(1), reverse=True)  


