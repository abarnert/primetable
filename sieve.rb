#!/usr/bin/env ruby

def primesto(n)
  # For n small enough to print a table, a straightforward sieve of
  # Eratosthenes should be fine. With the square optimization, it's
  # approximately O(n) time, and of course O(n) space.
  primes = Array.new n+1, true
  primes[0] = primes[1] = false
  2.step n**0.5 do |i|
    if primes[i] then
      (i**2).step n+1, i do |j|
        primes[j] = false
      end
    end
  end
  (2..n).select { |i| primes[i] }
end

p = primesto ARGV[0].to_i
puts "#{p[-1]}"
