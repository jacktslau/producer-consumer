require_relative '../account_service'
require_relative '../account'
require_relative '../transaction'

RSpec.describe AccountService do

  it 'initialize number of accounts according to size' do
    service = AccountService.new 3
    expect(service.get_accounts.size).to eq(3)
  end

  it 'random a transaction should generated from the accounts it owned' do
    service = AccountService.new 3
    accIds = service.get_accounts.map { |a| a.id }
    txn = service.random_transaction 'pid'
    expect(accIds.include? txn.account_id).to eq(true)
    expect(txn.producer_id).to eq('pid')
  end

end
