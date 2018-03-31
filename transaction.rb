require 'mongoid'

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
  include Mongoid::Document

  field :producer_id, type: String
  field :type, type: Integer
  field :amount, type: Float
  field :create_at, type: DateTime

  embedded_in :account

  def account_id
    account._id
  end

  def to_view
    {
        :id => _id,
        :producer_id => producer_id,
        :account_id => account_id.to_s,
        :type => TransactionType.value_of(type),
        :amount => amount,
        :create_at => create_at
    }
  end

  def to_s
    "Transaction (id=#{_id}, producer_id=#{producer_id}, accountId=#{account_id}, type=#{TransactionType.value_of(type)}, amount=#{amount}, create_at=#{create_at})"
  end

end
