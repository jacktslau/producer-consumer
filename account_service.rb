require_relative 'account'
require_relative 'transaction'

require 'json'
require 'mongo'
require 'mongoid'

class AccountService

  def initialize(accountSize = 10)
    @transactionTypes = [TransactionType::PAYMENT, TransactionType::TOPUP]

    Account.collection.drop
    accountSize.times do
      randomAccount
    end
  end

  def getAccounts
    Account.all
  end

  def getAccount(id)
    Account.find(id)
  end

  def getAccountTransaction(id)

  end

  def randomAccount
    Account.create(balance: 10000, createTs: Time.now, updateTs: Time.now, transactions: [])
  end

  def randomTransaction(producerId)
    randAcc = Account.all.sample
    randTxnType = @transactionTypes.sample
    randAmt = rand(1...100)
    Transaction.create(account: randAcc, producerId: producerId, type: randTxnType, amount: randAmt, createTs: Time.now)
  end

  def applyTransaction(transaction)
    accId = transaction.account._id
    acc = Account.find(accId)
    if !acc.nil?

      case transaction.type
        when TransactionType::PAYMENT
          acc.inc(balance: -(transaction.amount)).update(updateTs: Time.now)

        when TransactionType::TOPUP
          acc.inc(balance: transaction.amount).update(updateTs: Time.now)
      end

      return getAccount(accId)

    else
      return nil
    end
  end

end
