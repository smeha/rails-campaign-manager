class CampaignsController < ApplicationController
	before_action :logged_in_user

	def new
		@campaign  = sess_current_user.campiagns.new
	end

	def index
		#@campaign = Campaign.all
		@campaign = sess_current_user.campaigns.all
	end

	def create_json
		if sess_loggedin?
			@campaign = sess_current_user.campaigns.build(campaign_params)
			if @campaign.save
				render :json => @campaign.to_json, :status => :created
			else
				render :json => @campaign.errors.to_json, :status => :unprocessable_entity 
			end
		else			
			render json: { error: 'unauthorized' }
		end
	end

	def destroy_json
		if sess_loggedin?
			@campaign = sess_current_user.campaigns.find(params[:id])
			if @campaign 
				@campaign.destroy
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
			@campaign = sess_current_user.campaigns.all
			render json:  @campaign.to_json 
		else			
			render json: { error: 'unauthorized' }
		end
	end
	
	def create
		@campaign = sess_current_user.campaigns.build(campaign_params)
		if @campaign.save
			flash[:success] = "New campaign has been created!"
			redirect_to @campaign
		else
			render 'new'
		end
	end

	def edit
		@campaign = sess_current_user.campaigns.find(params[:id])
	end

	def update
		@campaign = sess_current_user.campaigns.find(params[:id])
		if @campaign.update_attributes(campaign_params)
			flash[:success] = "The campaign has been updated"
			redirect_to @campaign
		else
			render 'edit'
		end
	end

	def destroy
		@campaign = sess_current_user.campaigns.find(params[:id])
	if @campaign 
		@campaign.destroy
		flash[:success] = "The campaign has been deleted"
	else
		flash[:alert] = "The campaign was not found"
	end
		redirect_to root_path
	end

	def show
		@campaign = Campaign.find_by(params[:id])
	end

	private
	def campaign_params
		params.require(:campaign).permit(:name,:start_date,:end_date, :end_time, :start_time)
	end

end
