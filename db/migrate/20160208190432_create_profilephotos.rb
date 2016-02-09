class CreateProfilephotos < ActiveRecord::Migration
  def change
    create_table :profilephotos do |t|
      t.boolean :deleted
      t.datetime :deleted_at
      t.integer :user_id
      t.string :user_uid
      t.string :source
      t.string :uuid
      t.string :direct_upload_url
      t.timestamps null: false
    end
    add_attachment :profilephotos, :image
    change_column :users, :uid, :string
    remove_column :users, :uuid
  end
end
