require 'thread'

class ProducerConsumer
  def initialize producers = 5, consumers = 5, queue_size = 5
    @producers, @consumers = producers, consumers
    @queue = SizedQueue.new queue_size
    @mutex = Mutex.new
    @threads = []
  end

  def run
    producers
    consumers
  end

  def producers
    @producers.times do
      @threads << Thread.new do
        loop do
          @queue << 'a widget'
          say "Produced a widget: #{@queue.size} in queue..."
        end
      end
    end
  end

  def consumers
    @consumers.times do
      @threads << Thread.new do
        loop do
          @queue.pop
          say "Consumed a widget: #{@queue.size} in queue..."
        end
      end
    end
  end

  def say this
    @mutex.synchronize do
      puts this
    end
  end

  def kill
    @threads.each &:kill
  end
end

pc = ProducerConsumer.new
pc.run
sleep 0.5
pc.kill