FactoryBot.define do
  factory :user, aliases: [:author, :responsible] do
    sequence(:email) { |n| "user_#{n}@test.com" }
    password { "password" }
  end
end
