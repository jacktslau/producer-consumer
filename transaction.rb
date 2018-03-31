require 'date'
require 'uuidtools'
require 'json'

module TransactionType
  PAYMENT = 1
  TOPUP = 2

  def self.value_of(value)
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

  attr_reader :id, :producer_id, :account_id, :type, :amount, :create_at

  def initialize (producer_id, account_id, type, amount, create_at = Time.now, id = UUIDTools::UUID.timestamp_create)
    @id = id
    @producer_id = producer_id
    @account_id = account_id
    @type = type
    @amount = amount
    @create_at = create_at
  end

  def to_hash
    {
        :id => @id.to_s,
        :producer_id => @producer_id,
        :account_id => @account_id.to_s,
        :type => TransactionType.value_of(@type),
        :amount => @amount,
        :create_at => @create_at
    }
  end

  def to_json
    to_hash.to_json
  end

  def to_s
    "Transaction (id=#{@id}, producer_id=#{@producer_id}, account_id=#{@account_id}, type=#{@type}, amount=#{@amount}, create_at=#{@create_at})"
  end

end
