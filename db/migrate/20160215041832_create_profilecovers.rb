class CreateProfilecovers < ActiveRecord::Migration
  def change
    create_table :profilecovers do |t|
      t.boolean :deleted
      t.datetime :deleted_at
      t.integer :user_id
      t.string :user_uid
      t.string :source
      t.string :uuid
      t.string :direct_upload_url
      t.boolean :processed
      t.boolean :skip_everafter
      t.timestamps null: false
    end
    add_attachment :profilecovers, :image
  end
end
