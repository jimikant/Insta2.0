# frozen_string_literal: true

require 'redis'

r = Redis.new
r.select(9)
r.del('myset')
r.sadd('myset', (0..999).to_a)
freq = {}
500.times do
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

# Print the frequency each element was yeld to process it with gnuplot
freq.each do |item, count|
  puts "#{item} #{count}"
end
