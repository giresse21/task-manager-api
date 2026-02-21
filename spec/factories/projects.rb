FactoryBot.define do
  factory :project do
    name { "MyString" }
    description { "MyText" }
    color { "MyString" }
    user { nil }
  end
end
