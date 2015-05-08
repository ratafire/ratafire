class AddFacebookPageCheckForUser < ActiveRecord::Migration
  def up
  	add_column :subscription_applications, :facebookpage_clicked, :boolean
  end

  def down
  end
end
