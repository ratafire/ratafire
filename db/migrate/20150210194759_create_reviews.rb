class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.integer :project_id
      t.integer :discussion_id
      t.text :content
      t.string :title
      t.integer :user_id
      t.boolean :admin_review, :default => false
      t.timestamps
    end
  end
end
