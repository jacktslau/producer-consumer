require 'thread'
require 'logger'

class Consumer

  attr_reader :size

  def initialize(size = 1, queue, &callback)
    @logger = Logger.new('log/consumer.log')
    @size = size
    @queue = queue
    @callback = callback
    @threads = []
  end

  # Start number of `size` consumers
  def start
    @size.times do
      @threads << Thread.new do
        run
      end
    end
  end

  private def run
    loop do
      msg = @queue.pop
      @logger.info "Received #{msg}"
      @callback.call(msg)
    end
  end

  def kill
    @threads.each &:kill
  end

end