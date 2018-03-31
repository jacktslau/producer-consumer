require 'mongoid'

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
  include Mongoid::Document

  field :producerId, type: String
  field :type, type: Integer
  field :amount, type: Float
  field :createTs, type: DateTime

  embedded_in :account

  def accountId
    account._id
  end

  def to_view
    {
      :id => _id,
      :producerId => producerId,
      :accountId => accountId.to_s,
      :type => TransactionType.valueOf(type),
      :amount => amount,
      :createTs => createTs
    }
  end

  def to_s
    "Transaction (id=#{_id}, producerId=#{producerId}, accountId=#{accountId}, type=#{TransactionType.valueOf(type)}, amount=#{amount}, createTs=#{createTs})"
  end

end
