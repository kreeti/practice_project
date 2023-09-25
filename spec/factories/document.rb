FactoryBot.define do
  factory :attachment do
    transaction_image { create :transaction }
    document { File.new(Rails.root.join("spec", "files", "response.png")) }
  end
end
