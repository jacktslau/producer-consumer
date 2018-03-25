require_relative '../account'
require_relative '../transaction'

RSpec.describe Account do

  it 'return error if transaction account id not match' do
    acc = Account.new 100
    txn = Transaction.new 'id', TransactionType::PAYMENT, 10
    applyAcc = acc.apply(txn)
    expect(applyAcc.balance).to eq(acc.balance)
  end

  it 'apply payment transaction and returns new account object' do
    acc = Account.new 100
    txn = Transaction.new acc.id, TransactionType::PAYMENT, 50
    applyAcc = acc.apply(txn)
    expect(acc.balance).to eq(100)
    expect(applyAcc.balance).to eq(50)
  end

  it 'not apply payment transaction if insufficient balance' do
    acc = Account.new 100
    txn = Transaction.new acc.id, TransactionType::PAYMENT, 500
    applyAcc = acc.apply(txn)
    expect(acc.balance).to eq(100)
    expect(applyAcc.balance).to eq(100)
  end

  it 'apply topup transaction and returns new account object' do
    acc = Account.new 100
    txn = Transaction.new acc.id, TransactionType::TOPUP, 100
    applyAcc = acc.apply(txn)
    expect(acc.balance).to eq(100)
    expect(applyAcc.balance).to eq(200)
  end
end
