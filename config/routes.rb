Rails.application.routes.draw do
  post 'user_token' => 'user_token#create'
  # Home controller routes.
  root   'home#index'
  get    'auth'            => 'home#auth'
  
  # Get login token from Knock
  post   'user_token'      => 'user_token#create'

  # User actions
  get    '/users'          => 'users#index'
  get    '/users/current'  => 'users#current'
  post   '/users/create'   => 'users#create'
  patch  '/user/:id'       => 'users#update'
  delete '/user/:id'       => 'users#destroy'

  # Quotes actions
  get    '/quotes'            => 'quotes#index'
  get    '/quotes/:search_tag' =>  'quotes#tag'

  #Cache actions
  get    '/cache/saved'    => 'cache#saved_quotes'
  get    '/cache/searched' => 'cache#searched_tags'
  delete '/cache/clean'    => 'cache#clean_cache'

end
