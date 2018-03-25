require_relative 'producer'
require_relative 'consumer'
require_relative 'message_queue'

puts "Init..."
q = MessageQueue.new
p = Producer.new 3, q
c = Consumer.new 1, q

puts "Starting Producer and Consumer..."
c.start
p.start

sleep(100)

puts "Stopping Producer and Consumer..."
p.kill
c.kill
q.clear
q.close

puts "Done."