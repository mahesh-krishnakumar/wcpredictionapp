after 'development:groups', 'teams' do
  require 'faker'

  puts 'Seeding Users'

  teams_or_nil = Team.all.to_a << nil
  User.create!(name: 'Mickey Mouse', email: Faker::Internet.email, nick_name: 'Mickey', password: 'Welcome#123', team: teams_or_nil.sample)
  User.create!(name: 'Donald Trump', email: Faker::Internet.email, nick_name: 'Trump', password: 'Welcome#123', team: teams_or_nil.sample)
  User.create!(name: 'Kummanam', email: Faker::Internet.email, nick_name: 'Kummanam', password: 'Welcome#123', team: teams_or_nil.sample)
  User.create!(name: 'Yedurappa', email: Faker::Internet.email, nick_name: 'Yedurappa', password: 'Welcome#123', team: teams_or_nil.sample)
  User.create!(name: 'Mangalasseri Neelakandan', email: Faker::Internet.email, nick_name: 'Neelakandan', password: 'Welcome#123', team: teams_or_nil.sample)
  User.create!(name: 'Anjooran', email: Faker::Internet.email, nick_name: 'Anjooran', password: 'Welcome#123', team: teams_or_nil.sample)
  User.create!(name: 'Prathapa Varma', email: Faker::Internet.email, nick_name: 'Prathapan', password: 'Welcome#123', team: teams_or_nil.sample)
  User.create!(name: 'Thomas Kutty', email: Faker::Internet.email, nick_name: 'Thomas', password: 'Welcome#123', team: teams_or_nil.sample)
  User.create!(name: 'Govindan Kutty', email: Faker::Internet.email, nick_name: 'Govindan', password: 'Welcome#123', team: teams_or_nil.sample)

  group_1_users = User.all.limit(4)
  group_2_users = User.all - group_1_users

  group_1_users.each do |user|
    user.groups << Group.first
  end

  group_2_users.each do |user|
    user.groups << Group.last
  end

  # Make few users part of multiple groups
  group_1_users.first.groups << Group.last
  group_2_users.first.groups << Group.first
end