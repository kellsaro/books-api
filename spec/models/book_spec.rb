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
#
# Indexes
#
#  index_books_on_category_id  (category_id)
#
# Foreign Keys
#
#  category_id  (category_id => categories.id)
#
require 'rails_helper'

RSpec.describe Book, type: :model do
  # Association test
  it { should belong_to(:category) }
  # Validation test
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:author) }
  it { should validate_length_of(:title).is_at_least(3) }
end
