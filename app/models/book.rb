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
class Book < ApplicationRecord
  belongs_to :category
  belongs_to :user
  
  validates :title, :author, presence: true, length: { minimum: 3 }
end
