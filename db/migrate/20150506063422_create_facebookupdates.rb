class CreateFacebookupdates < ActiveRecord::Migration
  def change
    create_table :facebookupdates do |t|
      t.integer :user_id
      t.boolean :deleted
      t.datetime :deleted_at
      t.integer :facebook_id
      t.integer :facebookpage_id
      t.string :uid
      t.string :from_category
      t.string :from_name
      t.string :from_id
      t.text :message
      t.string :story
      t.string :picture
      t.string :link
      t.string :source
      t.string :caption
      t.string :video_description
      t.string :post_type
      t.string :facebook_link
      t.string :event_name
      t.string :object_id
      t.string :status_type
      t.string :uuid
      t.string :page_id
      t.string :youtube_video
      t.string :vimeo_video
      t.string :name
      t.timestamps
    end

    add_attachment :facebookupdates, :picture
  end
end
