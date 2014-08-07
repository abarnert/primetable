#!/usr/bin/env python3

from collections import defaultdict, deque
import heapq
from itertools import count, islice

def dprimes():
    crossoffs = defaultdict(list)
    candidates = count(2)
    for candidate in candidates:
        if candidate in crossoffs:
            for crossoff in crossoffs[candidate]:
                crossoffs[candidate + crossoff].append(crossoff)
            del crossoffs[candidate]
        else:
            yield candidate
            crossoffs[candidate**2].append(candidate)

def hprimes():
    crossoffs = []
    for candidate in count(2):
        if crossoffs and candidate == crossoffs[0][0]:
            while candidate == crossoffs[0][0]:
                heapq.heappushpop(crossoffs, (crossoffs[0][0] + crossoffs[0][1],
                                              crossoffs[0][1]))
        else:
            yield candidate
            heapq.heappush(crossoffs, (candidate**2, candidate))
            
def firstprimes(n):
    return list(islice(dprimes(), n))

if __name__ == '__main__':
    import sys
    print(firstprimes(int(sys.argv[1]))[-1])
