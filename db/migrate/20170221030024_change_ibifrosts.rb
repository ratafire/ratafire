class ChangeIbifrosts < ActiveRecord::Migration
  def change
  	remove_column :ibifrosts, :project_id
  	add_column :ibifrosts, :item_id, :integer
  	add_column :ibifrosts, :item_type, :string
  	add_column :ibifrosts, :user_id, :integer
  	add_column :ibifrosts, :bifrost, :string
  	add_column :ibifrosts, :encrypted_bifrost, :string
  	add_column :ibifrosts, :bifrost_iv, :string
  end
end
