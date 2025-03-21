# order of routes matters!
Rails.application.routes.draw do
  resources :users
  resources :households, param: :invite_token, only: :show do
    resources :users, shallow: true # nests only index, new, and create under household
  end
  resources :egg_entries
  resource :session
  resources :passwords, param: :token
  resources :chickens
  resources :collection_entries do
    collection do
      get :today
    end
  end
  resources :households
  get '/signup' => 'users#new'
  get '/settings' => 'users#settings', as: :settings
  get '/faq' => 'marketing#faq'
  get '/collection_entries/today' => 'collection_entries#today', as: :today
  get '/how_it_works' => 'marketing#how_it_works', as: :how_it_works
  get '/acknowledgements' => 'marketing#acknowledgements', as: :acknowledgements
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
root "marketing#home"
end
