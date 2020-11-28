class AddTimesToCampaigns < ActiveRecord::Migration[6.0]
  def change
    add_column :campaigns, :start_time, :time
    add_column :campaigns, :end_time, :time
  end
end
