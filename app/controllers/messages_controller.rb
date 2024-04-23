class MessagesController < ApplicationController
  before_action :set_chat_and_application
  before_action :set_message, only: %i[ show update destroy ]

  # GET /applications/:application_token/chats/:chat_number/messages
  def index
    @messages = Message.where(chat_id: @chat.id).order(number: :desc)

    if @messages.empty?
      render json: { message: 'No messages found' }, status: :ok
    else
      render json: { data: @messages, message: 'Messages found' }, status: :ok
    end
  end

  # GET /applications/:application_token/chats/:chat_number/messages/search?q=foo
  def search
    @messages = Message.search(params[:q])

    @messages = @messages.where(chat_id: @chat.id)

    if @messages.empty?
      render json: { message: 'No messages found' }, status: :ok
    else
      render json: { data: @messages, message: 'Messages found' }, status: :ok
    end
  end

  # GET /applications/:application_token/chats/:chat_number/messages/:number
  def show
    if @message.nil?
      render json: { message: 'Message not found' }, status: :ok
    else
      render json: { data: @message, message: 'Message found' }, status: :ok
    end
  end

  # PATCH/PUT /applications/:application_token/chats/:chat_number/messages/:number
  def update
    if @message.update(update_message_params)
      render json: { data: @message, message: "Message updated" }, status: :ok
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  # DELETE /applications/:application_token/chats/:chat_number/messages/:number
  def destroy
    @message.destroy!
    render json: { message: "Message deleted" }, status: :ok
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find_by(chat_id: @chat.id, number: params[:number])
    end

    def set_chat_and_application
      @application = Application.find_by(token: params[:application_token])
      @chat = Chat.find_by(application_id: @application.id, number: params[:chat_number])
    end

    # Only allow a list of trusted parameters through.
    def create_message_params
      params.require(:message).permit(:body, :username)
    end

    def update_message_params
      params.require(:message).permit(:body)
    end
end
