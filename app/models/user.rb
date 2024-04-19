class User < ApplicationRecord
  has_many :messages
  validates :username, presence: true, uniqueness: true
end
