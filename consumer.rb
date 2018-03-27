require 'thread'

class Consumer

  attr_reader :size

  def initialize(size = 1, queue, &callback)
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
      @callback.call(msg)
    end
  end

  def kill
    @threads.each &:kill
  end

end