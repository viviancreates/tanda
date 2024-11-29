class ChangeWalletDataTypeToJsonb < ActiveRecord::Migration[7.1]
  def change
    change_column :users, :wallet_data, :jsonb, using: 'wallet_data::jsonb', default: {}
  end
end
