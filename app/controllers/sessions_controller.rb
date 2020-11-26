class SessionsController < ApplicationController
	def new
	end

	def create
		user = User.find_by(email: params[:session][:email].downcase)
		if user && user.authenticate(params[:session][:password])
			sess_login user
			# sess_redirect_back_or user # To view the user loggedin
			flash[:success] = "Successfully logged in"
			redirect_to root_url
		else
			flash.now[:danger] = 'Incorrect credentials'
			render 'new'
		end
	end

	def destroy
		sess_logout
		flash[:success] = "Successfully logged out"
		redirect_to root_url
	end
end
