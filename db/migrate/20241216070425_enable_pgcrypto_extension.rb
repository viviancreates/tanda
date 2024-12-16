class EnablePgcryptoExtension < ActiveRecord::Migration[7.0]
  def up
    enable_extension 'pgcrypto'
  end

  def down
    disable_extension 'pgcrypto'
  end
end
