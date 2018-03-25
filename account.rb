require_relative 'transaction'
require 'uuidtools'

class Account

  attr_reader :id, :balance, :createTs, :updateTs

  def initialize (balance, createTs = Time.now, updateTs = Time.now, id = UUIDTools::UUID.timestamp_create)
    @id = id
    @balance = balance
    @createTs = createTs
    @updateTs = updateTs
  end

  # Return a new account with transaction applied
  def apply (transaction)
    if @id != transaction.accountId
      return itself
    end

    case transaction.type
      when TransactionType::PAYMENT
        if(@balance >= transaction.amount)
          return self.copy(@balance - transaction.amount, @createTs, Time.now)
        end
      when TransactionType::TOPUP
        return self.copy(@balance + transaction.amount, @createTs, Time.now)
    end

    return itself
  end

  # Return a new account with new variables
  def copy (balance = @balance, createTs = @createTs, updateTs = @updateTs)
    Account.new balance, createTs, updateTs, @id
  end

  def display
    puts "Account (id=#{@id}, balance=#{@balance}, createTs=#{@createTs}, updateTs=#{@updateTs})"
  end

end
