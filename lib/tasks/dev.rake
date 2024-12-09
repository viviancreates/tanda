task sample_data: :environment do
  p "Creating sample data"

  if Rails.env.development?
    FollowRequest.destroy_all
    Transaction.destroy_all
    UserTanda.destroy_all
    Tanda.destroy_all
    User.destroy_all
  end
  
  vivian = User.create(
    email: "vivian@example.com",
    password: "password",
    first_name: "Vivian",
    last_name: "Davila",
    username: "Vivian",
    default_address: "0x12345",
    balance: 500.0
  )

  p "Created specific user: Vivian Davila"

  12.times do
    name = Faker::Name.first_name
    User.create(
      email: "#{name}@example.com",
      password: "password",
      first_name: name,
      last_name: Faker::Name.last_name,
      username: name,
      default_address: Faker::Blockchain::Ethereum.address,
      balance: rand(100.0..1000.0)
    )
  end
  
  p "There are now #{User.count} users."

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
 

  p "There are now #{FollowRequest.count} follow requests."

  10.times do
    
    Tanda.create(
      name: ["Wedding", "Vacation", "House", "Fun", "Car", "Family", "Budget", "Debt"].sample + " " + "Fund",
      goal_amount: rand(1000..5000),
      creator_id: User.all.sample.id,
      creator_wallet: Faker::Blockchain::Ethereum.address,
      due_date: Date.today + rand(30..60).days
    )
  end
  
  p "There are now #{Tanda.count} tandas."

  Tanda.all.each do |tanda|
    User.all.sample(rand(5..9)).each do |user|
      UserTanda.create(
        user_id: user.id,
        tanda_id: tanda.id,
      )
    end
  end

  p "There are now #{UserTanda.count} user_tandas."
  
  UserTanda.all.each do |user_tanda|
      Transaction.create(
        user_tanda_id: user_tanda.id,
        amount: rand(20..100),
        date: Date.today - rand(30..60),
        description: Faker::Lorem.sentence,
        transaction_type: ["deposit", "withdrawal"].sample
      )
end

p "There are #{Transaction.count} transactions."
end
