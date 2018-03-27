require_relative 'transaction'
require_relative 'account'

require 'thread'

class Producer

  attr_reader :size

  def initialize(size = 5, queue, accountService)
    @size = size
    @queue = queue
    @accountService = accountService
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
      pid = Thread.current.object_id
      transaction = @accountService.randomTransaction(pid)
      @queue << transaction
      @accountService.applyTransaction(transaction)
    end
  end

  def kill
    @threads.each &:kill

  end

end