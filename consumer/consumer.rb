require 'thread'
require 'logger'
require 'json'

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
        run
      end
    end
  end

  def run
    sleep(100)
    @queue.subscribe { |msg|
      @logger.info "Received #{msg}"
      @callback.call(JSON.parse(msg))
    }
  end

  def kill
    @threads.each &:kill
  end

end