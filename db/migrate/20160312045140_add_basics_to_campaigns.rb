class AddBasicsToCampaigns < ActiveRecord::Migration
  def change
  	add_column :campaigns, :sub_category, :string
  	add_column :campaigns, :country, :string
  	add_column :campaigns, :city, :string
  	add_column :campaigns, :duration, :integer
  	add_attachment :campaigns, :image
  	add_attachment :campaigns, :transcript
  end
end
