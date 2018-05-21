Sequel.migration do
  change do
    create_table(:accounts) do
      primary_key :id
      Float :balance, null: false
      DateTime :create_at, null: false
      DateTime :update_at, null: false
    end

    create_table(:transactions) do
      primary_key :id
      String :producer_id, null: false
      Integer :type, null: false
      Float :amount, null: false
      DateTime :create_at, null: false
      foreign_key :account_id, :accounts
    end
  end
end
