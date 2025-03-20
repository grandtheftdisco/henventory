# order of routes matters!
Rails.application.routes.draw do
  resources :households, param: :invite_token, only: :show do
    resources :users, shallow: true # nests only index, new, and create under household
    resource :invite_link, only: :show
    # 3/19 8:00 pm - right now I am able to create a proper invite link and sign up for a new account with it, but the household id isn't being passed - what ends up happening is that the new user gets a new household id. Fried from trying to troubleshoot so I am going to stop for the night. Maybe tomorrow I can try to write tests for this and/or look at the logic with fresh eyes. Whiteboard could be helpful.
    # 3/20 11:30am - read through first 2 sections of rails docs on routing. so far it all tracks & none of what i've read has helped me identify the problem.
    # my dev household was missing an invite token so i added one in the browser console on the error page -- then i refreshed the page and the token populated in the invite link field and in the test print line. then when i followed the invite link, i got an error saying that @household evaluated to nil
    # so yeah, even though the url 'works', the @household isn't being recognized, and in turn, this means the @household.id isn't being assigned to the user. i feel like my problem is because there's some part of this strategy that is specific to the 3-table schema example that doesn't apply to my situation, but i'm having trouble identifying the exact problem that's keeping the @household from being passed & assigned a value other than nil
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
  # resources :users
  get '/signup' => 'users#new'
  # post '/users' => 'users#create'
  get '/settings' => 'users#settings', as: :settings
  get '/faq' => 'marketing#faq'
  # post '/users' => 'users#update'
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
