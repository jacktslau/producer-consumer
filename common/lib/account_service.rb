require_relative 'account'
require_relative 'transaction'

require 'json'
require 'mongo'
require 'mongoid'

class AccountService

  def initialize(account_size = 10)
    @transaction_types = [TransactionType::PAYMENT, TransactionType::TOPUP]

    Account.collection.drop
    account_size.times do
      random_account
    end
  end

  def get_accounts
    Account.all
  end

  def get_account(id)
    Account.find(id)
  end

  def random_account
    Account.create(balance: 10000, create_at: Time.now, update_at: Time.now, transactions: [])
  end

  def random_transaction(producer_id)
    rand_acc = Account.all.sample
    rand_txn_type = @transaction_types.sample
    rand_amt = rand(1...100)
    Transaction.create(account: rand_acc, producer_id: producer_id, type: rand_txn_type, amount: rand_amt, create_at: Time.now)
  end

  def apply_transaction(transaction)
    acc_id = transaction.account._id
    acc = Account.find(acc_id)
    if !acc.nil?

      case transaction.type
        when TransactionType::PAYMENT
          acc.inc(balance: -(transaction.amount)).update(update_at: Time.now)

        when TransactionType::TOPUP
          acc.inc(balance: transaction.amount).update(update_at: Time.now)
      end

      return get_account(acc_id)
    else
      return nil
    end
  end

end
