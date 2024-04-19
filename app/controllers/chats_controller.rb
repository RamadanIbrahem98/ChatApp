class ChatsController < ApplicationController
  before_action :set_application
  before_action :set_chat, only: %i[ show update destroy ]

  # GET /applications/:application_token/chats
  def index
    @chats = Chat.where(application_id: @application.id).order(:number)

    render json: @chats
  end

  # GET /applications/:application_token/chats/:number
  def show
    render json: @chat
  end

  # POST /applications/:application_token/chats
  def create
    latest_number = Chat.where(application_id: @application.id).maximum(:number) || 0
    @chat = Chat.new(application_id: @application.id, number: latest_number + 1)

    if @chat.save
      # return what is equivalent to redirect_to application_chat_url(@application, @chat), status: :created but with json
      render json: @chat, status: :created, location: application_chat_url(@application, @chat)
    else
      render json: @chat.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /applications/:application_token/chats/:number
  def update
    if @chat.update(chat_params)
      render json: @chat
    else
      render json: @chat.errors, status: :unprocessable_entity
    end
  end

  # DELETE /applications/:application_token/chats/:number
  def destroy
    @chat.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_application
      @application = Application.find_by(token: params[:application_token])
    end

    def set_chat
      @chat = Chat.find_by(application_id: @application.id, number: params[:number])
    end

    # Only allow a list of trusted parameters through.
    def chat_params
      params.require(:chat).permit()
    end
end
