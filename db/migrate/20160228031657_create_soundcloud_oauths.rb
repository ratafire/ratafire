class CreateSoundcloudOauths < ActiveRecord::Migration
  def change
    create_table :soundcloud_oauths do |t|
      t.string :uuid
      t.integer :user_id
      t.boolean :deleted
      t.datetime :deleted_at
      t.string :name
      t.string :uid
      t.string :nickname
      t.string :image
      t.string :location
      t.string :token
      t.string :expires
      t.string :kind
      t.string :permalink
      t.string :fullname
      t.string :uri
      t.string :permalink_url
      t.string :avatar_url
      t.string :country 
      t.string :city
      t.string :track_count
      t.string :playlist_count
      t.string :public_favorites_count
      t.string :followers_count
      t.string :followings_count
      t.string :plan
      t.string :private_tracks_count
      t.string :private_playlists_count
      t.string :primary_email_confirmed
      t.timestamps null: false
    end
  end
end
