Rails.application.routes.draw do
  post 'user_token' => 'user_token#create'
  # Home controller routes.
  root   'home#index'
  get    'auth'            => 'home#auth'
  
  # Get login token from Knock
  post   'user_token'      => 'user_token#create'

  # User actions
  resources :users, only: [:index, :update, :destroy]
  get    '/users/current'  => 'users#current'
  post   '/users/create'   => 'users#create'

  # Quotes actions
  get    '/quotes/:search_tag' =>  'quotes#tag'

  #Cache actions
  get    '/cache/saved'    => 'cache#saved_quotes'
  get    '/cache/searched' => 'cache#searched_tags'
  delete '/cache/clean'    => 'cache#clean_cache'

end
