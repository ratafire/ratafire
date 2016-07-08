class CreateLikedCampaigns < ActiveRecord::Migration
  def change
    create_table :liked_campaigns do |t|
    	t.integer :user_id
    	t.integer :campaign_id
    	t.integer :liker_id
      t.timestamps null: false
    end
  end
end
