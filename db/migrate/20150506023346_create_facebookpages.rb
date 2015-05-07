class CreateFacebookpages < ActiveRecord::Migration
  def change
    create_table :facebookpages do |t|
      t.string :title
      t.string :tagline
      t.integer :user_id
      t.boolean :complete
      t.text :about
      t.integer :creator_id
      t.string :slug
      t.boolean :published
      t.integer :artwork_id
      t.text :perlink
      t.string :video_id
      t.integer :icon_id
      t.integer :goal
      t.string :source_code
      t.string :source_code_type
      t.string :source_code_title
      t.text :excerpt
      t.string :edit_permission
      t.boolean :flag
      t.datetime :completion_time
      t.string :realm
      t.datetime :comented_at
      t.boolean :abandoned, :default => false
      t.datetime :deleted_at
      t.boolean :deleted, :default => false
      t.boolean :featured, :default => false
      t.string :uuid
      t.boolean :test
      t.datetime :published_at
      t.boolean :early_access, :default => false
      t.integer :audio_id
      t.integer :pdf_id
      t.boolean :featured_home, :default => false
      t.string :sub_realm
      t.text :collectible
      t.string :website
      t.string :username
      t.string :name
      t.text :mission
      t.string :location
      t.string :category
      t.string :access_token
      t.string :page_id
      t.integer :facebook_id
      t.string :city
      t.string :country
      t.string :state
      t.string :link
      t.timestamps
    end
  end
end
