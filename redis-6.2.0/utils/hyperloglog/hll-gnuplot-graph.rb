# frozen_string_literal: true

# hll-err.rb - Copyright (C) 2014 Salvatore Sanfilippo
# BSD license, See the COPYING file for more information.
#
# This program is suited to output average and maximum errors of
# the Redis HyperLogLog implementation in a format suitable to print
# graphs using gnuplot.

require 'rubygems'
require 'redis'
require 'digest/sha1'

# Generate an array of [cardinality,relative_error] pairs
# in the 0 - max range, with the specified step.
#
# 'r' is the Redis object used to perform the queries.
# 'seed' must be different every time you want a test performed
# with a different set. The function guarantees that if 'seed' is the
# same, exactly the same dataset is used, and when it is different,
# a totally unrelated different data set is used (without any common
# element in practice).
def run_experiment(r, seed, max, step)
  r.del('hll')
  i = 0
  samples = []
  step = 1000 if step > 1000
  while i < max
    elements = []
    step.times do
      ele = Digest::SHA1.hexdigest(i.to_s + seed.to_s)
      elements << ele
      i += 1
    end
    r.pfadd('hll', elements)
    approx = r.pfcount('hll')
    err = approx - i
    rel_err = 100.to_f * err / i
    samples << [i, rel_err]
  end
  samples
end

def filter_samples(numsets, max, step, filter)
  r = Redis.new
  dataset = {}
  (0...numsets).each do |i|
    dataset[i] = run_experiment(r, i, max, step)
    warn "Set #{i}"
  end
  dataset[0].each_with_index do |ele, index|
    case filter
    when :max
      card = ele[0]
      err = ele[1].abs
      (1...numsets).each do |i|
        err = dataset[i][index][1] if err < dataset[i][index][1]
      end
      puts "#{card} #{err}"
    when :avg
      card = ele[0]
      err = 0
      (0...numsets).each do |i|
        err += dataset[i][index][1]
      end
      err /= numsets
      puts "#{card} #{err}"
    when :absavg
      card = ele[0]
      err = 0
      (0...numsets).each do |i|
        err += dataset[i][index][1].abs
      end
      err /= numsets
      puts "#{card} #{err}"
    when :all
      (0...numsets).each do |i|
        card, err = dataset[i][index]
        puts "#{card} #{err}"
      end
    else
      raise "Unknown filter #{filter}"
    end
  end
end

if ARGV.length != 4
  puts 'Usage: hll-gnuplot-graph <samples> <max> <step> (max|avg|absavg|all)'
  exit 1
end
filter_samples(ARGV[0].to_i, ARGV[1].to_i, ARGV[2].to_i, ARGV[3].to_sym)
