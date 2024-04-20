Rails.application.routes.draw do
  scope :api do
    scope :v1 do
      resources :users, param: :username
      resources :applications, param: :token do
        resources :chats, param: :number do
          resources :messages, param: :number do
            get 'search', to: 'messages#search', on: :collection
          end
        end
      end
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
