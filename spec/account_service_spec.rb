require_relative '../account_service'
require_relative '../account'
require_relative '../transaction'

RSpec.describe AccountService do

  it 'initialize number of accounts according to size' do
    service = AccountService.new 3
    expect(service.getAccounts.size).to eq(3)
  end

  it 'random a transaction should generated from the accounts it owned' do
    service = AccountService.new 3
    accIds = service.getAccounts.map { |a| a.id }
    txn = service.randomTransaction 'pid'
    expect(accIds.include? txn.accountId).to eq(true)
    expect(txn.producerId).to eq('pid')
  end

end
