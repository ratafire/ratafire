class CreateFacebooks < ActiveRecord::Migration
  def change
    create_table :facebooks do |t|
      t.string :uid
      t.string :name
      t.string :first_name
      t.string :last_name
      t.string :link
      t.string :username
      t.string :gender
      t.string :locale
      t.integer :age_min
      t.integer :age_max
      t.integer :user_id
      t.string :oauth_token
      t.datetime :oauth_expires_at
      t.timestamps
    end

    remove_column :users, :oauth_token
    remove_column :users, :oauth_expires_at
    remove_column :users, :facebook_oauth_token
    remove_column :users, :facebook_oauth_expired_at
    remove_column :users, :facebook
    remove_column :users, :twitter
    remove_column :users, :github
    remove_column :users, :deviantart
    remove_column :users, :vimeo

  end
end
