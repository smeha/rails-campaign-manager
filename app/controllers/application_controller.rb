class ApplicationController < ActionController::Base
include SessionsHelper

	private
	def logged_in_user
		unless sess_loggedin?
			sess_path
			flash[:danger] = "Need to login."
			redirect_to login_url
		end
	end
end
