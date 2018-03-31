require_relative 'transaction'
require_relative 'account'

require 'thread'
require 'logger'

class Producer

  attr_reader :size

  def initialize(size = 5, queue, service)
    @logger = Logger.new(STDOUT)
    @size = size
    @queue = queue
    @service = service
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
    transaction = @service.random_transaction(pid)
    @queue.push(transaction.to_full_json)
    updated_acc = @service.apply_transaction(transaction)
    if(!updated_acc.nil?)
      # After each transaction log the following information: producer_id, transaction_id, amount, side, balance (after an update).
      @logger.info "Producer ##{pid} generates $#{transaction.amount} #{TransactionType.value_of(transaction.type)} transaction ##{transaction.id} to Account ##{updated_acc.id} with updated balance: #{updated_acc.balance}"
    end
  end

  def kill
    @threads.each &:kill
  end

end