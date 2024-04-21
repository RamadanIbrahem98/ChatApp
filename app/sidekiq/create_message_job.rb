class CreateMessageJob
  include Sidekiq::Job
  queue_as :messages

  def perform(application_token, chat_number, username, body)
    @application = Application.find_by(token: application_token)
    @chat = Chat.find_by(application_id: @application.id,number: chat_number)
    @user = User.find_by(username: username)
    begin
      Message.custom_create!(body: body, user_id: @user.id, chat_id: @chat.id)
    rescue Faraday::ConnectionFailed => e
      if e.message.include?(":9200")
        puts "Elasticsearch is down"
        return
      end
    end
  end
end
