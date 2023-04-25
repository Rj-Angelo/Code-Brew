Rails.application.routes.draw do
  	root "puzzles#index"
	post "puzzles/validate_code/:id" => "puzzles#validate_code", as: "validate_puzzle"
	get "users/brew_puzzles" => "users#user_puzzles", as: "brew_puzzles"

	resources :sessions
	resources :users
	resources :puzzles do
		resources :forums
	end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
