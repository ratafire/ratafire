class CreateRewards < ActiveRecord::Migration
  def change
    create_table :rewards do |t|
    	t.integer :user_id
    	t.integer :campaign_id
    	t.integer :goal_id
    	t.decimal :amount, precision: 10, scale: 2
    	t.text :description
    	t.string :title
    	t.boolean :limited
    	t.integer :quantity
    	t.boolean :deleted
    	t.datetime :deleted_at
    	t.integer :backers, default: 0
    	t.integer :month
		t.integer :year
		t.datetime :estimated_delivery
		t.boolean :at_stock    	
		t.string :shipping
      t.timestamps null: false
    end
    add_attachment :rewards, :package
    add_attachment :rewards, :image
  end
end
