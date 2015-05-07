class AddCoverToBothFacebookPages < ActiveRecord::Migration
  def change
  	add_attachment :facebook_pages, :facebookcover
  	add_attachment :facebookpages, :facebookcover
  end
end
