class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from "chat_#{params[:room]}"
    ActionCable.server.broadcast("chat_Best Room", { body: "This Room is Best Room." })
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    ActionCable.server.broadcast "chat", message: data['message']
  end
end
