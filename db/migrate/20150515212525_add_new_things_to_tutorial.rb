class AddNewThingsToTutorial < ActiveRecord::Migration
  def change
  	add_column :tutorials, :facebook_page, :boolean
  	add_column :tutorials, :setup_subscription, :boolean
  end
end
