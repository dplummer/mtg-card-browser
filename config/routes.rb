Rails.application.routes.draw do
  get "search" => "cards#search"

  get "sets", to: "mtg_sets#index", as: "mtg_sets"

  get ":set_code/:language", to: "mtg_sets#show"

  get ":set_code/:language/:card_number(.:format)",
    to: "cards#show",
    as: "card",
    constraints: { card_number: /\d+/ }

  get ":set_code/:language/x:multiverse_id",
    to: "cards#show",
    as: "multiverse_card",
    constraints: { muiltiverse_id: /\d+/ }

  root "mtg_sets#index"
end
