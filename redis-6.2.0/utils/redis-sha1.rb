# frozen_string_literal: true

# redis-sha1.rb - Copyright (C) 2009 Salvatore Sanfilippo
# BSD license, See the COPYING file for more information.
#
# Performs the SHA1 sum of the whole datset.
# This is useful to spot bugs in persistence related code and to make sure
# Slaves and Masters are in SYNC.
#
# If you hack this code make sure to sort keys and set elements as this are
# unsorted elements. Otherwise the sum may differ with equal dataset.

require 'rubygems'
require 'redis'
require 'digest/sha1'

def redisSha1(opts = {})
  sha1 = ''
  r = Redis.new(opts)
  r.keys('*').sort.each do |k|
    vtype = r.type?(k)
    case vtype
    when 'string'
      sha1 = Digest::SHA1.hexdigest(sha1 + k)
      sha1 = Digest::SHA1.hexdigest(sha1 + r.get(k))
    when 'list'
      len = r.llen(k)
      if len != 0
        sha1 = Digest::SHA1.hexdigest(sha1 + k)
        sha1 = Digest::SHA1.hexdigest(sha1 + r.list_range(k, 0, -1).join("\x01"))
      end
    when 'set'
      len = r.scard(k)
      if len != 0
        sha1 = Digest::SHA1.hexdigest(sha1 + k)
        sha1 = Digest::SHA1.hexdigest(sha1 + r.set_members(k).to_a.sort.join("\x02"))
      end
    when 'zset'
      len = r.zcard(k)
      if len != 0
        sha1 = Digest::SHA1.hexdigest(sha1 + k)
        sha1 = Digest::SHA1.hexdigest(sha1 + r.zrange(k, 0, -1).join("\x01"))
      end
    end
    # puts "#{k} => #{sha1}" if len != 0
  end
  sha1
end

host = ARGV[0] || '127.0.0.1'
port = ARGV[1] || '6379'
db = ARGV[2] || '0'
puts "Performing SHA1 of Redis server #{host} #{port} DB: #{db}"
p "Dataset SHA1: #{redisSha1(host: host, port: port.to_i, db: db)}"
