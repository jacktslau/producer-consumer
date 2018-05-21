require_relative 'transaction'

Sequel::Model.plugin :json_serializer

class Account < Sequel::Model
  one_to_many :transactions

  def to_view
    v = values.clone
    v[:transactions] = transactions
    v
  end

  def to_s
    v = values
    txns = v[:transactions].map { |txn|
      txn.values
    }
    "Account (id=#{v[:id]}, balance=#{v[:balance]}, create_at=#{v[:create_at]}, update_at=#{v[:update_at]}, transactions=#{txns})"
  end

end
