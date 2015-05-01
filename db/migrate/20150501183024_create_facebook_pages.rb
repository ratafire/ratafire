class CreateFacebookPages < ActiveRecord::Migration
  def change
    create_table :facebook_pages do |t|
    	t.string :likes
    	t.string :website
    	t.string :username
    	t.string :name
    	t.text :mission
    	t.string :location
    	t.boolean :is_published
    	t.boolean :is_permanently_closed
    	t.boolean :is_community_page
    	t.string :hometown
    	t.string :global_brand_page_name
    	t.string :genre
    	t.string :general_manager
    	t.text :test
    	t.string :general_info
    	t.string :founded
    	t.string :email
    	t.string :directed_by
    	t.string :description
    	t.string :current_location
    	t.string :cover
    	t.string :contact_address
    	t.string :company_overview
    	t.string :category
    	t.string :booking_agent
    	t.string :bio
    	t.string :awards
    	t.string :attire
    	t.string :artists_we_like
    	t.string :app_id
    	t.string :affiliation
    	t.string :access_token
    	t.text :about
    	t.string :page_id
    	t.integer :facebook_id
    	t.integer :user_id
    	t.datetime :deleted_at
      	t.boolean :deleted
      	t.timestamps
    end
  end
end
