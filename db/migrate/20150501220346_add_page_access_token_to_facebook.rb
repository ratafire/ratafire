class AddPageAccessTokenToFacebook < ActiveRecord::Migration
  def change
  	add_column :facebooks, :page_access_token, :string
  end
end
