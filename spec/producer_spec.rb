require_relative '../account_service'
require_relative '../account'
require_relative '../transaction'
require_relative '../producer'

RSpec.describe Producer do

  before :each do
    @service = double('account_service')
    @queue = double('queue')
  end

  it 'apply transaction to account and push into queue' do
    txn = double
    allow(txn).to receive(:to_full_json) { txn }
    allow(@service).to receive(:random_transaction) { txn }
    expect(@queue).to receive(:push).with(txn)
    expect(@service).to receive(:apply_transaction).with(txn)

    Producer.new(1, @queue, @service).run
  end
end
