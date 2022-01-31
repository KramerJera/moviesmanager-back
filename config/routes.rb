Rails.application.routes.draw do
  resources :profiles do 
      resources :movies do
        collection do
          get '/search/:search_term', to: 'movies#search'
        end        
      end
  end

  
  root to: "home#index"

  post "refresh", controller: :refresh, action: :create
  post "signin", controller: :signin, action: :create
  post "signup", controller: :signup, action: :create
  delete "signin", controller: :signin, action: :destroy

end
