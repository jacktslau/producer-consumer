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
    attrs = as_json
    attrs['id'] = attrs.delete('_id').to_s
    attrs['account_id'] = account._id.to_s
    attrs['type'] = TransactionType.value_of(attrs['type'])
    attrs
  end

  def to_pretty_s
    "Transaction (id=#{_id.to_s}, producer_id=#{producer_id}, account_id=#{account_id.to_s}, type=#{TransactionType.value_of(type)}, amount=#{amount}, create_at=#{create_at})"
  end

end

