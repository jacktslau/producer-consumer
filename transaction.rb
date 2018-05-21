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

Sequel::Model.plugin :json_serializer

class Transaction < Sequel::Model(:transactions)
  many_to_one :accounts

  def to_view_json
    v = values.clone
    view_type = TransactionType.value_of(v[:type])
    v[:type] = view_type
    v.to_json
end

  def to_pretty_s
    v = values
    "Transaction (id=#{v[:id]}, producer_id=#{v[:producer_id]}, account_id=#{v[:account_id]}, type=#{TransactionType.value_of(v[:type])}, amount=#{v[:amount]}, create_at=#{v[:create_at]})"
  end

end
