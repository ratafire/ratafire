class AddDefaultToEmailReceiverCount < ActiveRecord::Migration
  def change
  	add_column :emails, :uuid, :string
  	change_column :emails, :receiver_count, :integer, :default => 0
  end
end
