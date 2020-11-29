# User controller for authentication
class UsersController < ApplicationController
	before_action :logged_in_user, only: [:show]

	def show
		if session[:user_id] && session[:user_id].to_i == params[:id].to_i
			@user = User.find(params[:id])
		else
			redirect_to root_url
		end
	end

	def new
		@user = User.new
	end

	def json_id_current_user
		@id = 0
		if sess_loggedin?
			@id = sess_current_user.id
			render json: { id: @id }
		else
			render json: { error: 'unauthorized' }
		end
	end

	def create
		@user = User.new(user_params)
		if @user.save
			sess_login @user
			flash[:success] = "Succesfully signed up and logged in"
			redirect_to root_url
			# redirect_to @user # To view the user loggedin
		else
			render 'new'
		end
	end

	private
	def user_params
		params.require(:user).permit(:name, :email, :password, :password_confirmation)
	end
end
