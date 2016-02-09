class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.string :image_best
      t.text :description
      t.string :best_title
      t.string :title
      t.string :root_url
      t.string :host
      t.boolean :tracked
      t.string :url
      t.string :majorpost_uuid
      t.boolean :deleted
      t.datetime :deleted_at
      t.timestamps null: false
    end
  end
end
