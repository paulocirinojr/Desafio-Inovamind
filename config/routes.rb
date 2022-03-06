Rails.application.routes.draw do
  resources :tags
  resources :quotes

  get '/quotes/:id', to: 'quotes#show'
  
end
