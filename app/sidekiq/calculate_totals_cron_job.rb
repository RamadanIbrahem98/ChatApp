class CalculateTotalsCronJob
  include Sidekiq::Job
  queue_as :default

  def perform(args = {})
    if args["type"] == "chats" and args["application_token"] != nil
      application = Application.find_by(token: args["application_token"])
      application.update!(chats_count: application.chats.count)
    elsif args["type"] == "messages" and args["application_token"] != nil and args["number"] != nil
      chat = Chat.find_by(application_id: args["application_token"], number: args["number"])
      chat.update!(messages_count: chat.messages.count)
    elsif args.blank?
      calculate_total_chats
      calculate_total_messages
    end
  end

  private

  def calculate_total_chats
    Application.find_each do |application|
      application.update!(chats_count: application.chats.count)
    end
  end

  def calculate_total_messages
    Chat.find_each do |chat|
      chat.update!(messages_count: chat.messages.count)
    end
  end
end
