require_relative 'transaction'
require_relative 'account'

require 'thread'
require 'logger'

class Producer

  attr_reader :size

  def initialize(size = 5, queue, accountService)
    @logger = Logger.new(STDOUT)
    @size = size
    @queue = queue
    @accountService = accountService
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
    sleep(rand(10))
    pid = Thread.current.object_id
    transaction = @accountService.randomTransaction(pid)
    @queue.push(transaction)
    updatedAcc = @accountService.applyTransaction(transaction)
    if(!updatedAcc.nil?)
      # After each transaction log the following information: producer_id, transaction_id, amount, side, balance (after an update).
      @logger.info "Producer ##{pid} generates $#{transaction.amount} #{TransactionType.valueOf(transaction.type)} transaction ##{transaction.id} to Account ##{updatedAcc.id} with updated balance: #{updatedAcc.balance}"
    end
  end

  def kill
    @threads.each &:kill
  end

end