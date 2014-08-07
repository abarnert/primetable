primetable
==========

Prime multiplication table

    $ ./primetable.rb 

Prints a multiplication table of the first 10 primes.

    $ ./primetable.rb 12
	
Prints a multiplication table of the first 12 primes.

Implementation
==============

`primetable.rb`
---------------

Main program, just calls `firstprimes` and formats the multiplication
table, nothing too exciting here.

`isieve.rb`
-----------

Implements `firstprimes n`, which generates the first `n` primes.

It uses an interleaved sieve of Eratosthenes, as described in
[The Genuine Sieve of Eratosthenes][1], but using a hash table instead
of a tree or a minheap/pqueue. Specifically, it's a hash of arrays,
where each prime is stored in the list under its next multiple
(starting at `p**2` and incrementing by `p`). Each time we hit a
multiple of `p`, we remove it and add the next multiple of `p` to the
hash.

  [1]: http://www.cs.hmc.edu/~oneill/papers/Sieve-JFP.pdf

For practical performance tests, I used a Python implementation,
mainly because I couldn't find a good minheap with a single-step
`pushpop` for Ruby, and Python has one in the stdlib. See `sieve.py`
below.

Theoretically, the average complexity should be `O(p log log p)`. 
Because we're using a hash of arrays, we can have worst-case complexity
of `O(p log log^2 p)` when a disproportionate number of primes'
next multiples overlap, but since the only region where that happens
before 10^12 is in the first few numbers (where the estimate says it
should be about 1.1 but it often hits 2) that scarcely matters.
Anyway, a minheap would solve that problem; more importantly, it
should give us a significantly lower constant--but only if the
minheap provides a push-and-pop in a single operation.

Space is `O(n)`, where `n` is the number of primes; at any given time,
the hash is storing each prime seen so far exactly once, and there's
also a simple list of primes for the return value. (I could have
created an `Enumerable` generator as the stdlib `primes` does, and as
my Python implementation does, but it seemed to overcomplicate things
for no real benefit in the actual program.)

I also didn't use any wheels for optimization, even the trivial
2-wheel, the program spends less than 1% of its time generating
primes, and at that point it seemed like readability was a bigger
win than speed. (Wheels aren't quite as simple with an interleaved
sieve as with a forward sieve, where you can just pre-mark-off the
table.)

In fact, given that the end goal is to print a multiplication table to
stdout, `p` is going to be tiny, so the right thing to do would be to
just hardcode an array of, say, 100 primes... but I figured that would
be cheating.

However, even without cheating, over-estimating the max prime and 
using a straightforward sieve would probably still be faster than 
using an interleaved sieve, especially together with preloading the 
first 100 primes or so (which is simpler with a normal sieve than 
preloading wheels for an interleaved sieve).

`isievetest.rb`
---------------

Unit tests for `isieve.rb`.

There really aren't any tricky cases (besides maybe 0, which isn't
relevant to the program), so I just test that `firstprimes 10000`
returns the exact same list as `Primes.first 10000`.

I added a benchmark test, but since the algorithm is not linear at the
very small scale (or, in theory, any other worst case) and I couldn't
find any documentation on adding performance assertions to
`MiniTest::Spec`, I just raised the scale by an order of magnitude and
asserted linear 0.999.

`sieve.rb`
----------

A straightforward sieve for primes up to `n` instead of the first `n`
primes, for performance testing. Over the same range, it takes 0.41x
as long.

`isieve.py`
-----------

A Python implementation of the same algorithm, for performance testing
of different data structures. The committed code doesn't include all
of the variations or the performance testing code, just the last two
implementations I tested.

Performance
===========

All tests performed on a MacBook Pro (Retina, Mid 2012) 2.6 GHz i7,
with CPython 3.4 from python.org and Ruby 2.0.0p481 from Apple. Tested
with `n=200000` (`p=2750159` for the non-interleaved sieves). Times 
normalized to 1.0 for `isieve.py` as implemented.

0.30: Python non-interleaved sieve
0.41: Ruby non-interleaved sieve (`sieve.rb`)
0.66: Python `heapq`
0.73: Python `dict`
0.97: Python `rbtrees.FastRBTree`
1.00: Ruby `hash` (`isieve.py`)
1.10: Python `heapq` without `pushpop`
