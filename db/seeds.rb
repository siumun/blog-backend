# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require "faker"
require "securerandom"
AdminUser.find_or_create_by!(email: 'admin@example.com') do |admin|
  admin.password = 'password'
  admin.password_confirmation = 'password'
end if Rails.env.development?

users_to_create = [2000 - User.count, 0].max

users_to_create.times do |i|
  user = User.new(
    name: Faker::Name.name,
    email: "test_user_#{SecureRandom.hex(8)}@example.com",
    password: "Password123!"
  )

  user.save!
end

puts "Users completed: #{User.count}"


posts_to_create = [10_000 - Post.count, 0].max
admin_ids = AdminUser.pluck(:id)
raise "No AdminUser found!" if admin_ids.empty?
posts_to_create.times do |i|
  Post.create!(
    title: Faker::Lorem.sentence,
    excerpt: Faker::Lorem.paragraph(sentence_count: 2),
    body: Faker::Lorem.paragraphs(number: 5).join("\n\n"),
    publication_date: rand(1..365).days.ago,
    view_count: rand(0..100_000),
    status: :published,
    admin_user_id: admin_ids.sample,

  )
end

puts "Posts completed: #{Post.count}"


user_ids = User.pluck(:id)
post_ids = Post.pluck(:id)

comments_to_create = [500_000 - Comment.count, 0].max
raise "No Users found!" if user_ids.empty?
raise "No Posts found!" if post_ids.empty?

comments_to_create.times do
  Comment.create!(
    user_id: user_ids.sample,
    post_id: post_ids.sample,
    body: Faker::Lorem.paragraph(sentence_count: 2)
  )
end

puts "Comments completed: #{Comment.count}"