# config/initializers/coinbase.rb
require 'coinbase'
api_key_name = ENV['COINBASE_API_KEY_NAME']
api_key_private_key = ENV['COINBASE_API_KEY_PRIVATE_KEY']

Coinbase.configure do |config|
  config.api_key_name = api_key_name
  config.api_key_private_key = api_key_private_key
end

Rails.logger.info("Coinbase SDK has been successfully configured.")
