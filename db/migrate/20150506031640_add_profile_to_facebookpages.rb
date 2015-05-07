class AddProfileToFacebookpages < ActiveRecord::Migration
  def change
  	add_attachment :facebookpages, :facebookprofile
  end
end
