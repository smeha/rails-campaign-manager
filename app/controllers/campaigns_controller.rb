class CampaignsController < ApplicationController
	before_action :logged_in_user

	def home
	end

	def new
		@campaign  = current_user.campiagns.new
	end

	def index
		@campaign = Campaign.all
	end

	def create
		@campaign = current_user.campaigns.build(item_params)
		if @campaign.save
			flash[:success] = "New campaign has been created!"
			redirect_to @campaign
		else
			render 'new'
		end
	end

	def edit
		@campaign = current_user.campaigns.find(params[:id])
	end

	def update
		@campaign = current_user.campaigns.find(params[:id])
		if @campaign.update_attributes(campaign_params)
			flash[:success] = "The campaign has been updated"
			redirect_to @campaign
		else
			render 'edit'
		end
	end

	def destroy
		@campaign = current_user.campaigns.find(params[:id])
	if @campaign 
		@campaign.destroy
		flash[:success] = "The campaign has been deleted"
	else
		flash[:alert] = "The campaign was not found"
	end
		redirect_to root_path
	end

	def show
		@campaign = Campaign.find(params[:id])
	end

	private
	def campaign_params
		params.require(:campaign).permit(:name,:start_date,:end_date)
	end

end
