require_relative 'transaction'

require 'uuidtools'
require 'json'

class Account

  attr_reader :id, :balance, :transactionLogs, :createTs, :updateTs

  def initialize (balance, createTs = Time.now, updateTs = Time.now, id = UUIDTools::UUID.timestamp_create)
    @id = id
    @balance = balance
    @createTs = createTs
    @updateTs = updateTs
    @lock = Mutex.new
    @transactionLogs = []
  end

  # Return account with transaction applied
  def apply (transaction)
    if @id != transaction.accountId
      return itself
    end

    @lock.synchronize do
      case transaction.type
        when TransactionType::PAYMENT
          @balance -= transaction.amount
          @updateTs = Time.now
          @transactionLogs << transaction
        when TransactionType::TOPUP
          @balance += transaction.amount
          @updateTs = Time.now
          @transactionLogs << transaction
      end
    end

    return itself
  end

  def to_hash
    txnLogHash = @transactionLogs.map { |t| t.to_hash }
    {
        :id => @id.to_s,
        :balance => @balance,
        :createTs => @createTs,
        :updateTs => @updateTs,
        :transactionLogs => txnLogHash
    }
  end

  def to_json
    to_hash.to_json
  end


  def display
    txnLogs = @transactionLogs.map { |txn|
      txn.display
    }
    puts "Account (id=#{@id}, balance=#{@balance}, createTs=#{@createTs}, updateTs=#{@updateTs}, transactionLogs=#{txnLogs})"
  end

end
