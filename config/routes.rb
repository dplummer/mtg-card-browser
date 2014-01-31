Rails.application.routes.draw do
  resources :mtg_sets
  resources :mtg_cards

  root "mtg_sets#index"
end
