class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
    	t.boolean :deleted
    	t.datetime :deleted_at
    	t.string :uuid
    	t.string :website
    	t.integer :leader_id
    	t.text :about
    	t.string :subscription_status_initial
    	t.datetime :goals_updated_at
    	t.decimal :subscription_amount, :default => 0.0, :precision => 8, :scale => 2
      t.timestamps
    end
    remove_column :users, :masked
    add_column :users, :organization_id, :integer
    add_column :users, :organization_leader_id, :integer
    add_column :videos, :organization_id, :integer
    add_column :patron_videos, :organization_id, :integer
    add_attachment :organizations, :icon
    add_attachment :organizations, :background
  end
end
