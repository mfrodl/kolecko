Rails.application.routes.draw do
  devise_for :teams,
    path: '', path_names: {
      sign_in: 'prihlaseni',
      sign_out: 'odhlaseni',
      sign_up: 'registrace',
    },
    controllers: {
      sessions: 'teams/sessions',
      registrations: 'teams/registrations'
    }

  root 'main#index'

  resources :teams, path: 'tymy'

  scope(path_names: {new: 'nova', edit: 'upravit'}) do
    resources :answers, path: 'odpovedi', only: [:index, :new, :create]
    resources :puzzles, path: 'sifry', only: [:index]

    resources :hint_requests, path: 'napovedy' do
      collection do
        get :queue, path: 'fronta'
      end
      member do
        get :answer, path: 'odpovedet', to: 'hints#new'
        post :answer, path: 'odpovedet', to: 'hints#create'
      end
    end
  end

  get '/pravidla', to: 'pages#show', as: :rules, page: 'rules'
  get '/vysledky', to: 'pages#show', as: :results, page: 'results'
end
