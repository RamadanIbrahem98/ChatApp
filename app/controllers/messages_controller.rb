class MessagesController < ApplicationController
  before_action :set_chat_and_application
  before_action :set_message, only: %i[ show update destroy ]

  # GET /applications/:application_token/chats/:chat_number/messages
  def index
    @messages = Message.where(chat_id: @chat.id).order(number: :desc)

    render json: @messages
  end

  # GET /applications/:application_token/chats/:chat_number/messages/search?q=foo
  def search
    @messages = Message.search(params[:q])

    @messages = @messages.where(chat_id: @chat.id)

    render json: @messages
  end

  # GET /applications/:application_token/chats/:chat_number/messages/:number
  def show
    render json: @message
  end

  # POST /applications/:application_token/chats/:chat_number/messages
  def create
    # this route is temporary, it will be processed by the action cable later
    @message = CreateMessageJob.perform_async(@application.token, @chat.number, current_user.username, create_message_params[:body])

    render json: { "msg": "message is being processed" }, status: :created
  end

  # PATCH/PUT /applications/:application_token/chats/:chat_number/messages/:number
  def update
    if @message.update(update_message_params)
      render json: @message
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  # DELETE /applications/:application_token/chats/:chat_number/messages/:number
  def destroy
    @message.destroy!
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
