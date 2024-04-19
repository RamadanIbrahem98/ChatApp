class Chat < ApplicationRecord
  belongs_to :application
  has_many :messages

  def as_json(options = {})
    super(options.merge(except: :id))
  end
end
