# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Category, type: :model do
  # Association test
  it { should have_many(:books) }
  # Validation test
  it { should validate_presence_of(:name) }
  it { should validate_length_of(:name).is_at_least(3) }
end
