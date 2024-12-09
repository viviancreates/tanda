require "coinbase"

api_key_name = ENV['API_KEY_NAME']
api_key_private_key = ENV['API_KEY_PRIVATE_KEY'] 

Coinbase.configure do |config|
  config.api_key_name = api_key_name
  config.api_key_private_key = api_key_private_key
end

puts "Coinbase SDK has been successfully configured with CDP API key."
