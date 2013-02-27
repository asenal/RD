#!/usr/bin/python
import heapq

L=[1,2,3,4,5,6,7,8,9,10]
H=heapq.heapify(L)
heapq.heappush(H,0)
heapq.heappop(H)
heapq.heappushpop(H,-1)
heapq.heapreplace(H,100)


L1=[1,2,3,9,10]
L2=[5,8,12,15]
Lm=heapq.merge(L1,L2) # L1,L2 must be sorted,must!!!!!
L3=[7,4,2,9,10]
heapq.nlargest(2,L3) # don't have to be sorted.
heapq.nsmallest(2,L3)

# item can be nested data structure...
h = []
heapq.heappush(h, (2,3))
heapq.heappush(h, (1,9))
heapq.heappush(h, (-2,7))
heapq.heappush(h, (-2,0))
heapq.heappush(h, (5,1))
heapq.heappush(h, (5,10))

# priority queue using heapq
pq = []                         # list of entries arranged in a heap
entry_finder = {}               # mapping of tasks to entries
REMOVED = '<removed-task>'      # placeholder for a removed task
counter = itertools.count()     # unique sequence count

def add_task(task, priority=0):
    'Add a new task or update the priority of an existing task'
    if task in entry_finder:
        remove_task(task)
    count = next(counter)
    entry = [priority, count, task]
    entry_finder[task] = entry
    heappush(pq, entry)

def remove_task(task):
    'Mark an existing task as REMOVED.  Raise KeyError if not found.'
    entry = entry_finder.pop(task)
    entry[-1] = REMOVED

def pop_task():
    'Remove and return the lowest priority task. Raise KeyError if empty.'
    while pq:
        priority, count, task = heappop(pq)
        if task is not REMOVED:
            del entry_finder[task]
            return task
    raise KeyError('pop from an empty priority queue')
