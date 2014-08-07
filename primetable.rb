#!/usr/bin/env ruby

require './isieve'

n = 10
if ARGV.length > 0 then n = ARGV[0].to_i end

primes = firstprimes n
width = (primes[-1]**2).to_s.length + 1

puts ([''] + primes).map { |x| x.to_s.rjust width }.join ""
primes.each do |y|
  puts ([1] + primes).map { |x| (x*y).to_s.rjust width }.join ""
end
