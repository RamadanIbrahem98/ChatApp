class Users::SessionsController < Devise::SessionsController
  respond_to :json

  private  
    def respond_with(resource, _opts = {})
      puts resource.inspect, 'resource'
      render json: { message: 'Logged in.', data: UserSerializer.new(resource).serializable_hash[:data][:attributes] }, status: :ok
    end

    def respond_to_on_destroy
      current_user ? log_out_success : log_out_failure
    end
    
    def log_out_success
      render json: { message: "Logged out." }, status: :ok
    end
    def log_out_failure
      render json: { message: "Logged out failure."}, status: :unauthorized
    end
end
