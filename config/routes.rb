Rails.application.routes.draw do
  get "search" => "cards#search"

  get "sets", to: "mtg_sets#index", as: "mtg_set"

  get ":set_code/:language", to: "mtg_sets#show"

  get ":set_code/:language/:card_number", to: "cards#show", as: "card"

  root "mtg_sets#index"
end
