class SessionsController < ApplicationController
	def new	
	end

	def create
		user = User.new(login_params)
		if user.valid?(:login)
			authenticate_user();
		else
			flash[:errors] = user.errors.full_messages
			redirect_to new_session_path
		end
	end

	def destroy
		session[:user_id] = nil
		redirect_to new_session_path
	end

	private
	def login_params
		params.permit(:email, :password)
	end

	def authenticate_user()
		user = User.find_by(email: params[:email])
		unless user.nil?
			if user && user.authenticate(params[:password])
				session[:user_id] = user.id
				redirect_to "/"
			else
				flash[:errors] = "Wrong password"
				redirect_to new_session_path
			end
		else
			flash[:errors] = "User does not exist"
			redirect_to new_session_path
		end
	end
end
