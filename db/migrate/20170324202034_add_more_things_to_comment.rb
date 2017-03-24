class AddMoreThingsToComment < ActiveRecord::Migration
  def change
  	add_column :comments, :locale, :string
  	add_column :comments, :majorpost_user_id, :integer
  	add_column :comments, :campaign_id, :integer
  end
end
