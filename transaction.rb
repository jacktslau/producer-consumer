require 'date'
require 'uuidtools'

module TransactionType
  PAYMENT = 1
  TOPUP = 2
end

class Transaction

  attr_reader :id, :accountId, :type, :amount, :createTs

  def initialize (accountId, type, amount, createTs = Time.now, id = UUIDTools::UUID.timestamp_create)
    @id = id
    @accountId = accountId
    @type = type
    @amount = amount
    @createTs = createTs
  end

  def display
    puts "Transaction (id=#{@id}, accountId=#{@accountId}, type=#{@type}, amount=#{@amount}, createTs=#{@createTs})"
  end

end
