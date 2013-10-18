Easyblog::Application.routes.draw do
  authenticated :user do
    root :to => 'home#index'
  end
  root :to => "home#index"
  devise_for :users
  resources :users
  put "comments/vote_up/:id" => 'comments#vote_up', as: 'vote_up'
  put "comments/vote_down/:id" => 'comments#vote_down', as: 'vote_down'
  put "comments/mark_as_not_abusive/:id" => 'comments#mark_as_not_abusive', as: 'mark_as_not_abusive'
  resources :posts do
    resources :comments
    member do
      post :mark_archived
    end
  end
end
