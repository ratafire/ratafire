class CreateBlacklists < ActiveRecord::Migration
  def change
    create_table :blacklists do |t|
      t.integer :blacklister_id
      t.integer :blacklisted_id
      t.boolean :message, :default => false
      t.timestamps
    end
  end
end
