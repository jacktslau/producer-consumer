require_relative 'account'
require_relative 'transaction'

class AccountService

  def initialize(accountSize = 10)
    @transaction_types = [TransactionType::PAYMENT, TransactionType::TOPUP]
    @accounts = {}
    accountSize.times do
      rand = random_account
      @accounts[rand.id] = rand
    end
  end

  def get_accounts
    @accounts.values
  end

  def get_account(id)
    @accounts[id]
  end

  def random_account
    Account.new 10000
  end

  def random_transaction(producerId)
    rand_acc_key = @accounts.keys.sample
    rand_acc = @accounts[rand_acc_key]
    rand_txn_type = @transaction_types.sample
    rand_amt = rand(1...100)
    Transaction.new producerId, rand_acc.id, rand_txn_type, rand_amt
  end

  def apply_transaction(transaction)
    acc_id = transaction.account_id
    if @accounts.key?(acc_id)
      acc = @accounts[acc_id]
      return acc.apply(transaction)
    else
      return nil
    end
  end

end
