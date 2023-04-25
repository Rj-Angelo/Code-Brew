class UsersController < ApplicationController
	before_action :check_user, except: [:new, :create]

	def new
	end

	def edit
	end

	def update
		user = current_user
		user.update(registration_params)
		if user.valid?
			redirect_to "/"
		else
			flash[:errors] = user.errors.full_messages
			redirect_to edit_user_path(current_user)
		end
	end
	
	def create
		user = User.create(registration_params)
		if user.valid?
			session[:user_id] = user.id
			redirect_to "/"
		else
			flash[:errors] = user.errors.full_messages;
			redirect_to new_user_path
		end
	end

	def user_puzzles
		@user_puzzles = current_user.puzzles
		render "brew_puzzles"
	end

	private
	def registration_params
		params.permit(:username, :email, :password, :password_confirmation)
	end
end
