require 'minitest/autorun'
require 'minitest/benchmark'
require 'prime'
require 'set'

require './isieve'

class TestFirstprimes < MiniTest::Unit::TestCase
  def test_firstprimes
    right_answers = Set.new (Prime.first 10000)
    test_answers = Set.new (firstprimes 10000)
    assert_equal right_answers, test_answers
  end
  def bench_firstprimes
    # There doesn't seem to be a way to assert O(n log log n)
    # and MiniTest::Spec isn't documented so I'm not sure how
    # to add my own test. But within the range used by the
    # benchmarking code, linear 0.999 is close enough to
    # the real performance 0.9999, so I've cheated here.
    assert_performance_linear 0.999 do |n| firstprimes n*10 end
  end
end
