class AddMaskedToFacebookPages < ActiveRecord::Migration
  def change
  	add_column :facebookpages, :facebook_page_id, :integer
  end
end
