class User < ApplicationRecord
  has_many :messages
  validates :username, presence: true, uniqueness: true

  def as_json(options = {})
    super(options.merge(except: :id))
  end
end
