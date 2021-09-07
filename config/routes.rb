Rails.application.routes.draw do

  #ユーザー新規登録、ログイン
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }
  #会員側
  root to: 'public/homes#top'
  get "about" => "public/homes#about"
  scope module: :public do
    #会員の記述
    resources :users, only: [:show, :edit, :update] do
      member do
        get 'unsubscribe'
        patch 'withdraw'
        get 'product'
        get 'favorite'
        get 'review'
        get 'room'
      end
    end

    #商品の記述
    resources :products, except: [:destroy] do
      member do
        get 'image'
        patch 'addition'
      end
      #いいね機能の記述
      resource :favorites, only: [:create, :destroy]
      collection do
        post 'confirm'
      end
      #レビューの記述
      resources :reviews do
        collection do
          post 'confirm'
      end
    end

    end



    #チャットルームの記述
    resources :rooms, only: [:create,:show] do
      collection do
        post 'confirm'
      end
    end

    #チャットの記述
    resources :direct_messages, only: [:create]

    #問い合わせの記述
    resources :contacts, only: [:index, :create] do
      collection do
        post 'confirm'
        get 'thanx'
      end
    end

    #問い合わせメッセージの記述
    resources :contact_messages, only: [:create]

    #通知の記述
    resources :notifications, only: [:index]

    #検索の記述
    get 'search' => 'searches#search'

  end

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
