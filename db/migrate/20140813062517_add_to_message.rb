class AddToMessage < ActiveRecord::Migration
  def up
  	add_column :messages, :title, :string
  	add_column :messages, :content, :text
  	add_column :messages, :receiver_id, :integer
  end

  def down
  end
end
