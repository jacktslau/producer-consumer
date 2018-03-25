require 'thread'

class Producer

  def initialize size = 5, queue
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
      sleep(rand(10))
      tid = Thread.current.object_id
      @queue << "#{tid}> a msg #{Time.now.to_s}"
    end
  end

  def kill
    @threads.each &:kill
  end

end