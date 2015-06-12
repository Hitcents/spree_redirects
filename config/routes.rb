Spree::Core::Engine.routes.draw do
  namespace :admin do
    resources :redirects
  end
end
