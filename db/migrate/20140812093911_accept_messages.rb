class AcceptMessages < ActiveRecord::Migration
  def up
  	add_column :users, :accept_message, :boolean, :default => true
  end

  def down
  end
end
