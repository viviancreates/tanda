require "coinbase"
# Replace with your actual API key and private key.
api_key_name = ENV['API_KEY_NAME']  # Set your API key name in environment variables or directly
api_key_private_key = ENV['API_KEY_PRIVATE_KEY']  # Set your private key in environment variables or directly

Coinbase.configure do |config|
  config.api_key_name = api_key_name
  config.api_key_private_key = api_key_private_key
end

puts "Coinbase SDK has been successfully configured with CDP API key."
