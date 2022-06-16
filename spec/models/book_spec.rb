# == Schema Information
#
# Table name: books
#
#  id          :integer          not null, primary key
#  author      :string
#  title       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  category_id :integer          not null
#  user_id     :integer
#
# Indexes
#
#  index_books_on_category_id  (category_id)
#  index_books_on_user_id      (user_id)
#
# Foreign Keys
#
#  category_id  (category_id => categories.id)
#  user_id      (user_id => users.id)
#
require "rails_helper"

RSpec.describe Book, type: :model do
  describe "Associations" do
    it { should belong_to(:category) }
    it { should belong_to(:user) }
  end

  describe "Validations" do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:author) }
    it { should validate_length_of(:title).is_at_least(3) }
    it { should validate_length_of(:author).is_at_least(3) }
  end
end
