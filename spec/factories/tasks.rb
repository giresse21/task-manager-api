FactoryBot.define do
  factory :task do
    title { "MyString" }
    description { "MyText" }
    completed { false }
    priority { "MyString" }
    due_date { "2026-02-21" }
    user { nil }
    project { nil }
  end
end
