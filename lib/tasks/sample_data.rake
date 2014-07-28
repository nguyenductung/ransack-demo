namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
    make_entries
    make_relationships
    make_comments
  end
end

def make_users
  User.create!(name: "NgDucTung",
               email: "nguyen.duc.tung@framgia.com",
               password: "123456",
               password_confirmation: "123456",
               admin: true)

  User.create!(name: "Guest",
               email: "example@railstutorial.org",
               password: "123456",
               password_confirmation: "123456")

  99.times do |n|
    name  = Faker::Name.name
    email = "example-#{n+1}@gmail.com"
    password  = "123456"
    User.create!(name: name,
                 email: email,
                 password: password,
                 password_confirmation: password)
  end
end

def make_entries
  users = User.all(limit: 6)
  25.times do |n|
    users.each do |user|
      title = Faker::Lorem.sentence(1).to(-2)
      content = Faker::Lorem.paragraph((5..20).to_a.sample)
      user.entries.create!(title: title, content: content)
    end
  end
end

def make_relationships
  users = User.all
  user  = users.first
  followed_users = users[2..50]
  followers      = users[3..40]
  followed_users.each { |followed| user.follow!(followed) }
  followers.each      { |follower| follower.follow!(user) }
end

def make_comments
  users = User.all
  user  = users.first
  followed_users = user.followed_users
  followers = user.followers

  followers.each do |follower|
    entry = user.entries.first
    content = Faker::Lorem.sentence(20)
    follower.comment!(entry, content) unless entry.nil?
  end

  followed_users.each do |followed|
    entry = followed.entries.first
    content = Faker::Lorem.sentence(20)
    user.comment!(entry, content) unless entry.nil?
  end

  entry = user.entries.first
  content = Faker::Lorem.sentence(20)
  user.comment!(entry, content) unless entry.nil?
end