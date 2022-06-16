# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "rails_helper"

RSpec.describe Category, type: :model do
  describe "Associations" do
    it { should have_many(:books) }
  end

  describe "Validations" do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_least(3) }
  end
end
