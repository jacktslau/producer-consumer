require_relative 'transaction'

require 'mongoid'

class Account
  include Mongoid::Document

  field :balance, type: Float
  field :create_at, type: DateTime
  field :update_at, type: DateTime
  embeds_many :transactions

  def to_s
    txns = @transactions.map { |txn|
      txn.to_s
    }
    "Account (id=#{@id}, balance=#{@balance}, create_at=#{@create_at}, update_at=#{@update_at}, transactions=#{txns})"
  end

end
