json.extract! transaction, :id, :user_tanda_id, :amount, :date, :description, :transaction_type, :created_at, :updated_at
json.url transaction_url(transaction, format: :json)
