class CreateChatsJob
  include Sidekiq::Job
  queue_as :chats

  def perform(application_token)
    @application = Application.find_by(token: application_token)
    Chat.custom_create!(application_id: @application.id)
  end
end
