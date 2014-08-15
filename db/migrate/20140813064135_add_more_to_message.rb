class AddMoreToMessage < ActiveRecord::Migration
  def change
  	add_column :messages, :sender_id, :integer
  	add_column :messages, :conversation_id, :integer
  end
end
