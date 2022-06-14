# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  password_digest :string
#  username        :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Associations' do
    it { should have_many(:books) } 
  end

  describe 'Validations' do
    it { should validate_presence_of(:username) }
    it { should validate_uniqueness_of(:username) }
    it { should validate_length_of(:username).is_at_least(3) }
    it { should validate_presence_of(:password) }
    it { should validate_length_of(:password).is_at_least(10) }
  end
end
