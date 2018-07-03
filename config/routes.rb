Rails.application.routes.draw do
  devise_for :teams, controllers: {
    sessions: 'teams/sessions'
  }

  root 'main#index'

  resources :teams

  get '/pravidla', to: 'pages#show', as: :rules, page: 'rules'
  get '/vysledky', to: 'pages#show', as: :results, page: 'results'
  get '/sifry', to: 'pages#show', as: :puzzles, page: 'puzzles'
end
