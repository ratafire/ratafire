class AddDeleteionToRecipients < ActiveRecord::Migration
  def change
  	add_column :recipients, :deleted, :boolean
  	add_column :recipients, :deleted_at, :datetime
  end
end
