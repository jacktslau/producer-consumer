require_relative 'account'
require_relative 'transaction'

require 'json'

class AccountService

  def initialize(db, account_size = 10)
    @transaction_types = [TransactionType::PAYMENT, TransactionType::TOPUP]
    @db = db

    db_acc_count = Account.count
    if(db_acc_count < account_size)
      (account_size - db_acc_count).times do
        random_account
      end
    end

  end

  def get_accounts
    Account.all
  end

  def get_txn_accounts
    txn_acc = Account.eager(:transactions).all
    txn_acc
  end

  def get_account(id)
    Account[id]
  end

  def random_account
    Account.create(:balance => 10000, :create_at => Time.now, :update_at => Time.now)
  end

  def random_transaction(producer_id)
    rand_acc_id = get_accounts.sample.id
    rand_txn_type = @transaction_types.sample
    rand_amt = rand(1...100)
    Transaction.create(:account_id => rand_acc_id, :producer_id => producer_id, :type => rand_txn_type, :amount => rand_amt, :create_at => Time.now)
  end

  def apply_transaction(transaction)
    @db.transaction do
      acc_id = transaction.account_id
      acc = Account.for_update.first(id: acc_id)
      if !acc.nil?

        case transaction.type
          when TransactionType::PAYMENT
            new_balance = acc.balance - transaction.amount
            Account[acc_id].update(:balance => new_balance, :update_at => Time.now)

          when TransactionType::TOPUP
            new_balance = acc.balance + transaction.amount
            Account[acc_id].update(:balance => new_balance, :update_at => Time.now)
        end

        return get_account(acc_id)
      else
        return nil
      end
    end
  end

end
