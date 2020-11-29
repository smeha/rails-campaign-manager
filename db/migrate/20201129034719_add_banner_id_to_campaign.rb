class AddBannerIdToCampaign < ActiveRecord::Migration[6.0]
  def change
  	add_reference(:campaigns, :banners, index: false)
  end
end
