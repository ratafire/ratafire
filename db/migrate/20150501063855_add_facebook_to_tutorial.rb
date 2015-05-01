class AddFacebookToTutorial < ActiveRecord::Migration
  def change
  	add_column :tutorials, :facebook, :boolean
  end
end
