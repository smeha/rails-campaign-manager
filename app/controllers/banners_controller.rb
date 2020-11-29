class BannersController < ApplicationController
	before_action :logged_in_user
	def index
		@banner = sess_current_user.banners.all
	end

	def create_json
		if sess_loggedin?
			@banner = sess_current_user.banners.build(banner_params)
			if @banner.save
				render :json => @banner.to_json, :status => :created
			else
				render :json => @banner.errors.to_json, :status => :unprocessable_entity 
			end
		else			
			render json: { error: 'unauthorized' }
		end
	end

	def destroy_json
		if sess_loggedin?
			@banner = sess_current_user.banners.find(params[:id])
			if @banner 
				@banner.destroy
				respond_to do |format|
					format.html
      				format.json { head :no_content }
				end
			end
		else			
			render json: { error: 'unauthorized' }
		end
	end
	def show_json
		if sess_loggedin?
			@banner = sess_current_user.banners.all
			render json:  @banner.to_json 
		else			
			render json: { error: 'unauthorized' }
		end
	end

	private
	def banner_params
		params.require(:banner).permit(:name,:text)
	end
end
