class ChatChannel < ApplicationCable::Channel
  def subscribed
    reject_unless_chat_exists
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def receive(data)
    application = Application.find_by(token: params[:application_token])
    chat = Chat.find_by(application_id: application.id, number: params[:chat_number])
    CreateMessageJob.perform_async(application.token, chat.number, current_user.username, data["body"])

    ActionCable.server.broadcast("application#{params[:application_token]}_chat_#{params[:chat_number]}", data.merge({ username: current_user.username }))
  end

  private

  def reject_unless_chat_exists
    application = Application.find_by(token: params[:application_token])
    chat = Chat.find_by(application_id: application.id, number: params[:chat_number])
    if chat
      stream_from "application_#{params[:application_token]}_chat_#{params[:chat_number]}"
    else
      reject
    end
  end
end
