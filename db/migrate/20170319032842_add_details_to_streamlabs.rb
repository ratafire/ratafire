class AddDetailsToStreamlabs < ActiveRecord::Migration
  def change
  	add_column :streamlabs, :access_token, :string
  	add_column :streamlabs, :expires_in, :integer
  	add_column :streamlabs, :token_type, :string
  	add_column :streamlabs, :refresh_token, :string
  end
end
