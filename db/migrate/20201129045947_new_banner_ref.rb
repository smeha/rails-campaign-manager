class NewBannerRef < ActiveRecord::Migration[6.0]
  def change
  	remove_reference :campaigns, :banners, index: false
  	add_reference(:campaigns, :banners, index: true, foreign_key: {on_delete: :cascade})
  end
end
