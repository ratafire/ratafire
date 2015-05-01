class AddFacebookPageUid < ActiveRecord::Migration
  def up
  	add_column :facebook_pages, :uid, :string
  end

  def down
  end
end
