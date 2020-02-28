Rails.application.routes.draw do
  devise_for :users
  resources :questions do
    resources :answers, shallow: true, only: %i[create update destroy]
    patch 'mark_answer/:answer_id',
          to: 'questions#mark_answer',
          defaults: { format: :js },
          as: :mark_answer_for,
          on: :member
  end

  root to: 'questions#index'
end
