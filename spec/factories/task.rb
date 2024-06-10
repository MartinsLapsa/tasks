FactoryBot.define do
  factory :task do
    sequence(:name) { |n| "Task No. #{n}" }
    responsible
    author
    state { "draft" }
    deadline { Date.today }
    description { "Description" }
  end
end
