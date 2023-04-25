FactoryBot.define do
  factory :user_puzzle do
    user { nil }
    puzzle { nil }
    completed { false }
  end
end
