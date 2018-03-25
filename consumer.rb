require 'thread'

class Consumer

  def initialize size = 1, queue
    @size = size
    @queue = queue
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
      puts "Received #{msg}"
    end
  end

  def kill
    @threads.each &:kill
  end

end