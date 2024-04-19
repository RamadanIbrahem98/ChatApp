class Message < ApplicationRecord
  belongs_to :user
  belongs_to :chat

  def as_json(options = {})
    super(options.merge(except: :id))
  end
end
