#!/usr/bin/env ruby

def firstprimes(n)
  if n<1 then return [] end
  # Since we don't know the nth prime in advance, we can't use a
  # straightforward sieve of Eratosthenes. So instead we use an
  # incremental sieve--queue up all the crossoffs and do them as we
  # reach them, as described in The Genuine Sieve of Eratosthenes
  # http://www.cs.hmc.edu/~oneill/papers/Sieve-JFP.pdf. Since we're
  # using a hash rather than a tree for our table, the performance
  # should be O(n log log n).
  primes = []
  crossoffs = Hash.new
  inf = 1.0 / 0.0
  (2..inf).each do |candidate|
    if crossoffs.has_key?(candidate) then
      crossoffs[candidate].each do |crossoff|
        (crossoffs[candidate+crossoff] ||= []) << crossoff
      end
      crossoffs.delete candidate
    else
      primes << candidate
      if primes.length == n then break end
      (crossoffs[candidate**2] ||= []) << candidate
    end
  end
  primes
end
