class ExpandCampaigns < ActiveRecord::Migration
  def change
    change_table :campaigns do |t|
      t.references :client
      t.integer :mpx_campaign_id
    end
  end
end
