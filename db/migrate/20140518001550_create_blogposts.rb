class CreateBlogposts < ActiveRecord::Migration
  def change
    create_table :blogposts do |t|
      t.integer :user_id
      t.string :title
      t.string :slug
      t.string :category
      t.text :content
      t.text :excerpt
      t.timestamps
    end
  end
end
