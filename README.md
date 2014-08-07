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
of a tree or a minheap/pqueue. Specifically, it's a hash of lists,
where each prime is stored in the list under its next multiple
(starting at `p**2` and incrementing by `p`). Each time we hit a
multiple of `p`, we remove it and add the next multiple of `p` to the
hash.

  [1]: http://www.cs.hmc.edu/~oneill/papers/Sieve-JFP.pdf

Because we're using a hash, the worst-case complexity should be `O(p
log p)`, where `p` is the nth prime, but the amortized average case
should be `O(p)`, rather than the worst-and-average `O(p log log p)`
for a tree, or the worst `O(p log log p)` and average `O(p)` for a
minheap. (The proof requires some number theory on primes; see the
cited paper.) The constant overhead is definitely higher than for a
minheap as well, but only if the minheap provides a push-and-pop in a
single operation, and none of the minheap/pqueue/heapq/etc. gems I
could find had such a thing, so the actual performance.

Space is `O(n)`, where `n` is the number of primes; at any given time,
the hash is storing each prime seen so far exactly once, and there's
also a simple list of primes for the return value. (I could have
created an `Enumerable` generator as the stdlib `primes` does, and as
my Python implementation does, but it seemed to overcomplicate things
for no real benefit in the actual program.)

I also didn't use any wheels for optimization, even the trivial
2-wheel. The program spends less than 1% of its time generating
primes, so that seemed like overkill.

In fact, given that the end goal is to print a multiplication table to
stdout, n is going to be tiny, so the right thing to do would be to
just hardcode an array of, say, 100 primes... but I figured that would
be cheating.

However, assuming small n, over-estimating the max prime and using a
straightforward sieve would probably still be faster than using an
interleaved sieve, especially together with preloading the first 100
primes or so (which is simpler with a normal sieve than preloading
wheels for an interleaved sieve).

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
of different data structures. With CPython 3.4 vs. Ruby
2.0.0, compared to the Ruby version, the Python dict (hash) takes
0.73x as long, the heap with pushpop 0.66x, and the heap with separate
push and pop 1.1x.
