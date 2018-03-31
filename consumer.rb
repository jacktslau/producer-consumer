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
        run
      end
    end
  end

  def run
    @queue.subscribe { |msg|
      @logger.info "Received #{msg}"
      txn = Transaction.new_from_json(msg)
      @callback.call(txn.to_view)

    }
  end

  def kill
    @threads.each &:kill
  end

end