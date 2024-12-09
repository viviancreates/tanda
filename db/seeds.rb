# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
puts "Creating sample data..."

# Create a specific user
vivian = User.create(
  email: "vivian@example.com",
  password: "password",
  first_name: "Vivian",
  last_name: "Davila",
  username: "Vivian",
  default_address: "0x12345",
  balance: 500.0
)

puts "Created specific user: Vivian Davila"

# Create additional users
12.times do
  name = Faker::Name.first_name
  User.create(
    email: "#{name.downcase}@example.com",
    password: "password",
    first_name: name,
    last_name: Faker::Name.last_name,
    username: name.downcase,
    default_address: Faker::Blockchain::Ethereum.address,
    balance: rand(100.0..1000.0)
  )
end

puts "There are now #{User.count} users."

users = User.all

# Create follow requests
users.each do |first_user|
  users.each do |second_user|
    next if first_user == second_user
    if rand < 0.75
      first_user.sent_follow_requests.create(
        recipient: second_user,
        status: FollowRequest.statuses.keys.sample,
      )
    end
  end
end

puts "There are now #{FollowRequest.count} follow requests."

# Create tandas
5.times do
  Tanda.create(
    name: ["Wedding", "Vacation", "House", "Fun", "Car", "Family", "Budget", "Debt"].sample + " Fund",
    goal_amount: rand(1000..5000),
    creator_id: users.sample.id,
    creator_wallet: Faker::Blockchain::Ethereum.address,
    due_date: Date.today + rand(30..60).days
  )
end

puts "There are now #{Tanda.count} tandas."

# Add users to tandas
Tanda.all.each do |tanda|
  users.sample(rand(5..9)).each do |user|
    UserTanda.create(
      user_id: user.id,
      tanda_id: tanda.id,
    )
  end
end

puts "There are now #{UserTanda.count} user_tandas."

# Create transactions for each UserTanda
UserTanda.all.each do |user_tanda|
  Transaction.create(
    user_tanda_id: user_tanda.id,
    amount: rand(20..100),
    date: Date.today - rand(30..60),
    description: Faker::Lorem.sentence,
    transaction_type: ["deposit", "withdrawal"].sample
  )
end

puts "There are #{Transaction.count} transactions."
puts "Sample data creation complete!"
