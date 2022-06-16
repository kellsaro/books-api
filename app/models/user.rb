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
class User < ApplicationRecord
  has_secure_password
  has_many :books

  validates :username, presence: true, uniqueness: true, length: {minimum: 3}
  validates :password, presence: true, length: {minimum: 10}
end
