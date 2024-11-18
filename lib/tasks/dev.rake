task sample_data: :environment do
  p "Creating sample data"

  if Rails.env.development?
    Transaction.destroy_all
    UserTanda.destroy_all
    Tanda.destroy_all
    User.destroy_all
  end
  
  12.times do
    name = Faker::Name.first_name
    User.create(
      email: "#{name}@example.com",
      password: "password",
      first_name: name,
      last_name: Faker::Name.last_name,
      username: name,
    )
  end
  
  p "There are now #{User.count} users."

  4.times do
    
    Tanda.create(
      name: "#{Faker::Lorem.word.capitalize} Fund",
      goal_amount: rand(1000..5000),
      creator_id: User.all.sample.id,
      due_date: Date.today + rand(30..60), 
    )
  end
  
  p "There are now #{Tanda.count} tandas."

  Tanda.all.each do |tanda|
    User.all.sample(rand(2..5)).each do |user|
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
        date: Date.today,
        description: Faker::Lorem.sentence,
        transaction_type: ["deposit", "withdrawal"].sample
      )
end

p "There are #{Transaction.count} transactions."
end
