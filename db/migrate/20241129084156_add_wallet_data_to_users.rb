class AddWalletDataToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :wallet_data, :json
  end
end
