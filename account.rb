require_relative 'transaction'

require 'uuidtools'
require 'json'

class Account

  attr_reader :id, :balance, :transactions, :create_at, :update_at

  def initialize (balance, create_at = Time.now, update_at = Time.now, id = UUIDTools::UUID.timestamp_create)
    @id = id
    @balance = balance
    @create_at = create_at
    @update_at = update_at
    @lock = Mutex.new
    @transactions = []
  end

  # Return account with transaction applied
  def apply (transaction)
    if @id != transaction.account_id
      return itself
    end

    @lock.synchronize do
      case transaction.type
        when TransactionType::PAYMENT
          @balance -= transaction.amount
          @update_at = Time.now
          @transactions << transaction
        when TransactionType::TOPUP
          @balance += transaction.amount
          @update_at = Time.now
          @transactions << transaction
      end
    end

    return itself
  end

  def to_hash
    hash = @transactions.map { |t| t.to_hash }
    {
        :id => @id.to_s,
        :balance => @balance,
        :create_at => @create_at,
        :update_at => @update_at,
        :transactions => hash
    }
  end

  def to_json
    to_hash.to_json
  end


  def to_s
    txns = @transactions.map { |txn|
      txn.to_s
    }
    "Account (id=#{@id}, balance=#{@balance}, create_at=#{@create_at}, update_at=#{@update_at}, transactions=#{txns})"
  end

end
