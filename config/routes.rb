Rails.application.routes.draw do
  # El orden en el que define sus rutas es crucial para el diseño
  # y las rutas de los usuarios, ya que en algunos casos pueden terminar superpuestas.

  root 'users#index'
  devise_for :users
  resources :users, only: %i[index show] do
    resources :friendships, only: %i[create] do
      collection do
        get 'accept_friend'
        get 'decline_friend'
      end
    end
  end

  # También se agregó un enlace de ruta PUT al método update_img en el controlador de Usuarios.
  # Utilizamos PUT porque las solicitudes PUT y PATCH se usan para actualizar los datos existentes.
  put '/users/:id', to: 'users#update_img'

  resources :posts, only: %i[index new create show destroy] do
    resources :likes, only: %i[create]
  end

  resources :comments, only: %i[new create destroy] do
    resources :likes, only: %i[create]
  end
  # get 'friendships/create'
  # get 'likes/create'
  # get 'comments/new'
  # get 'comments/create'
  # get 'posts/index'
  # get 'posts/show'
  # get 'posts/new'
  # get 'posts/create'
  # get 'users/index'
  # get 'users/show'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
