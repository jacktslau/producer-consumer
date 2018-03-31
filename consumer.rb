require 'thread'
require 'logger'

class Consumer

  attr_reader :size

  def initialize(size = 1, queue, &callback)
    @logger = Logger.new(STDOUT)
    @size = size
    @queue = queue
    @callback = callback
    @threads = []
  end

  # Start number of `size` consumers
  def start
    @size.times do
      @threads << Thread.new do
        loop do
          run
        end
      end
    end
  end

  def run
    msg = @queue.pop
    if(!msg.nil?)
      @logger.info "Received #{msg}"
      @callback.call(msg.to_view)
    end
  end

  def kill
    @threads.each &:kill
  end

end