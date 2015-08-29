class AddMaskedToFacebookpage < ActiveRecord::Migration
  def change
  	add_column :facebookpages, :masked, :boolean
  	add_column :facebookpages, :memorized_fullname, :string
  end
end
