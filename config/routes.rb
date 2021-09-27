Rails.application.routes.draw do
  devise_for :admins, controllers: {
    sessions: 'admins/sessions',
  }
  # 管理者側
  namespace :admin do
    # 問い合わせの記述
    resources :contacts, only: [:show] do
      member do
        patch 'completed'
      end
    end
    # 会員の記述
    resources :users, only: [:index, :show, :edit, :update]
    # 商品の記述
    resources :products do
      # レビューの記述
      resources :reviews, only: [:show, :destroy]
    end
    # 商品画像の記述
    resources :product_images, only: [:update, :destroy]
    # ジャンルの記載
    resources :genres, only: [:index, :create, :edit, :update, :destroy]
    # 問い合わせメッセージの記述
    resources :contact_messages, only: [:create]
  end

  get '/admin' => 'admin/homes#top'

  # ユーザー新規登録、ログイン
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
  }
  # 会員側
  root to: 'public/homes#top'
  get "about" => "public/homes#about"
  scope module: :public do
    # 会員の記述
    resources :users, only: [:show, :edit, :update] do
      member do
        get 'unsubscribe'
        patch 'withdraw'
        get 'favorite'
        get 'review'
        get 'room'
      end
    end

    # 商品の記述
    resources :products, except: [:destroy, :new] do
      member do
        get 'image'
        patch 'addition'
      end
      collection do
        post 'confirm'
      end
      # いいね機能の記述
      resource :favorites, only: [:create, :destroy]
      # レビューの記述
      resources :reviews, except: [:new] do
        member do
          get 'image'
          patch 'addition'
        end
        collection do
          post 'confirm'
        end
      end
    end
    # 商品画像の記述
    resources :product_images, only: [:update, :destroy]

    # レビュー画像の記述
    resources :review_images, only: [:update, :destroy]

    # チャットルームの記述
    resources :rooms, only: [:create, :show]

    # チャットの記述
    resources :direct_messages, only: [:create]

    # 問い合わせの記述
    resources :contacts, only: [:index, :create] do
      collection do
        post 'confirm'
        get 'thanx'
      end
    end

    # 問い合わせメッセージの記述
    resources :contact_messages, only: [:create]

    # 検索の記述
    get 'search' => 'searches#search'
  end
end
