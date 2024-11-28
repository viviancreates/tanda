class AddCreatorWalletToTandas < ActiveRecord::Migration[7.1]
  def change
    add_column :tandas, :creator_wallet, :string
  end
end
