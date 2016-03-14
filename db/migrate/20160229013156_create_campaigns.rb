class CreateCampaigns < ActiveRecord::Migration
  def change
    create_table :campaigns do |t|
    	t.boolean :deleted
    	t.datetime :deleted_at
    	t.integer :user_id
    	t.string :uuid
    	t.string :category
    	t.string :title
    	t.text :description
    	t.datetime :completed_at
    	t.boolean :completed
    	t.boolean :published
    	t.datetime :published_at
    	t.datetime :expiration
    	t.string :subcategory
      t.timestamps null: false
    end
  end
end
