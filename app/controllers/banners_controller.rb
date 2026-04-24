class BannersController < ApplicationController
  before_action :logged_in_user

  def index
    @banner = sess_current_user.banners.all
  end
end
