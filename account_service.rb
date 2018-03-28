require_relative 'account'
require_relative 'transaction'

class AccountService

  def initialize(accountSize = 10)
    @transactionTypes = [TransactionType::PAYMENT, TransactionType::TOPUP]
    @accounts = {}
    accountSize.times do
      rand = randomAccount
      @accounts[rand.id] = rand
    end
  end

  def getAccounts
    @accounts.values
  end

  def getAccount(id)
    @accounts[id]
  end

  def randomAccount
    Account.new 10000
  end

  def randomTransaction(producerId)
    randAccKey = @accounts.keys.sample
    randAcc = @accounts[randAccKey]
    randTxnType = @transactionTypes.sample
    randAmt = rand(1...100)
    Transaction.new producerId, randAcc.id, randTxnType, randAmt
  end

  def applyTransaction(transaction)
    accId = transaction.accountId
    if @accounts.key?(accId)
      acc = @accounts[accId]
      return acc.apply(transaction)
    else
      return nil
    end
  end

end
