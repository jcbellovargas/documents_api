#!/usr/bin/env ruby
require 'bunny'

connection = Bunny.new
connection.start

channel = connection.create_channel

queue = channel.queue('test queue')

channel.default_exchange.publish("holaaaaaa", routing_key: queue.name)

puts " [x] Sent 'holaaaaa!'"

connection.close