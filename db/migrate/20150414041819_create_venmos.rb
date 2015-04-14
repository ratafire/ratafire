class CreateVenmos < ActiveRecord::Migration
  def change
    create_table :venmos do |t|
      t.string :uid
      t.string :username
      t.string :email
      t.string :name
      t.string :first_name
      t.string :last_name
      t.string :image
      t.string :balance
      t.string :profile_url
      t.string :token
      t.boolean :expires
      t.integer :user_id
      t.datetime :deleted_at
      t.boolean :deleted
      t.timestamps
    end
  end
end
