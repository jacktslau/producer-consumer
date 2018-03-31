require_relative 'transaction'

require 'mongoid'

class Account
  include Mongoid::Document

  field :balance, type: Float
  field :createTs, type: DateTime
  field :updateTs, type: DateTime
  embeds_many :transactions

  def to_s
    txnLogs = transactions.map { |txn|
      txn.to_s
    }
    "Account (id=#{_id}, balance=#{balance}, createTs=#{createTs}, updateTs=#{updateTs}, transactions=#{txnLogs})"
  end

end
