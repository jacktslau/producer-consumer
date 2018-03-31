require 'kafka'

module MessageQueue
  def push(msg)
    raise 'Not implemented'
  end

  def pop
    raise 'Not implemented'
  end

  def clear
    raise 'Not implemented'
  end

  def size
    raise 'Not implemented'
  end

  def close
    raise 'Not implemented'
  end

end

class SimpleMessageQueue
  include MessageQueue

  def initialize
    @queue = Queue.new
  end

  def push(msg)
    @queue << msg
  end

  def pop
    @queue.pop
  end

  def clear
    @queue.clear
  end

  def size
    @queue.size
  end

  def close
    @queue.close
  end

end

class KafkaMessageQueue
  include MessageQueue

  def initialize
    @kafka = Kafka.new(["#{ENV['KAFKA_HOST']}:#{ENV['KAFKA_PORT']}"])
    @producer = @kafka.async_producer(
      delivery_threshold: 10,
      delivery_interval: 5
    )
    @consumer = @kafka.consumer(group_id: 'consumer')
    @consumer.subscribe(ENV['KAFKA_TOPIC'])
  end

  def push(msg)
    @producer.produce(msg, topic: ENV['KAFKA_TOPIC'])
  end

  def subscribe
    @consumer.each_message do |msg|
      yield msg.value
    end
  end

  def close
    @producer.shutdown
    trap('TERM') { @consumer.stop }
  end
end