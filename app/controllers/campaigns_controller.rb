class CampaignsController < ApplicationController
  before_action :logged_in_user

  def index
    @campaign = sess_current_user.campaigns.all
  end
end
