class AddReceiverCountToEmail < ActiveRecord::Migration
  def change
  	add_column :emails, :receiver_count, :integer
  end
end
