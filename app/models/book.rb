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
class Book < ApplicationRecord
  belongs_to :category
  validates :title, :author, presence: true, length: { minimum: 3 }
end
