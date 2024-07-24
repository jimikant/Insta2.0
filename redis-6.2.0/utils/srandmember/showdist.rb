# frozen_string_literal: true

require 'redis'

r = Redis.new
r.select(9)
r.del('myset')
r.sadd('myset', (0..999).to_a)
freq = {}
100.times do
  res = r.pipelined do
    1000.times do
      r.srandmember('myset')
    end
  end
  res.each do |ele|
    freq[ele] = 0 if freq[ele].nil?
    freq[ele] += 1
  end
end

# Convert into frequency distribution
dist = {}
freq.each_value do |count|
  dist[count] = 0 if dist[count].nil?
  dist[count] += 1
end

min = dist.keys.min
max = dist.keys.max
(min..max).each do |x|
  count = dist[x]
  count = 0 if count.nil?
  puts "#{x} -> #{'*' * count}"
end
