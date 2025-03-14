# order of routes matters!
Rails.application.routes.draw do
  resources :households
  resources :egg_entries
  resource :session
  resources :passwords, param: :token
  resources :chickens
  resources :collection_entries do
    collection do
      get :today
    end
  end
  get '/users/edit/me' => 'users#edit', as: :edit_user # find way to remove the id# @ end of url
  resources :users
  get '/signup' => 'users#new'
  post '/users' => 'users#create'
  get '/settings' => 'marketing#settings', as: :settings
  get '/faq' => 'marketing#faq'
  post '/users' => 'users#update'
  get '/collection_entries/today' => 'collection_entries#today', as: :today
  # update all other routes with this syntax
  ########################
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
