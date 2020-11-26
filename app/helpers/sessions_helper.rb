module SessionsHelper
	def sess_login(user)
		session[:user_id] = user.id
	end

	def sess_current_user
		if session[:user_id]
			@sess_current_user ||= User.find_by(id: session[:user_id])
		end
	end

	def sess_loggedin?
		!sess_current_user.nil?
	end

	def sess_logout
		session.delete(:user_id)
		@sess_current_user = nil
	end

	def sess_current_user?(user)
		user == sess_current_user
	end

	def sess_redirect_back_or(default)
		redirect_to(session[:forwarding_url] || default)
		session.delete(:forwarding_url)
	end

	def sess_path
		session[:forwarding_url] = request.original_url if request.get?
	end
end
