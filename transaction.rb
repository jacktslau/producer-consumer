require 'date'
require 'uuidtools'
require 'json'

module TransactionType
  PAYMENT = 1
  TOPUP = 2

  def self.valueOf(value)
    case value
      when TransactionType::PAYMENT
        return "PAYMENT"
      when TransactionType::TOPUP
        return "TOPUP"
      else
        raise ArgumentError, "Invalid Transaction Type: #{value}"
    end
  end

end

class Transaction

  attr_reader :id, :accountId, :type, :amount, :createTs

  def initialize (producerId, accountId, type, amount, createTs = Time.now, id = UUIDTools::UUID.timestamp_create)
    @id = id
    @producerId = producerId
    @accountId = accountId
    @type = type
    @amount = amount
    @createTs = createTs
  end

  def to_hash
    {
        :id => @id.to_s,
        :producerId => @producerId,
        :accountId => @accountId.to_s,
        :type => TransactionType.valueOf(@type),
        :amount => @amount,
        :createTs => @createTs
    }
  end

  def to_json
    to_hash.to_json
  end

  def to_s
    "Transaction (id=#{@id}, producerId=#{@producerId}, accountId=#{@accountId}, type=#{@type}, amount=#{@amount}, createTs=#{@createTs})"
  end

end
