class AddToMailboxerConversation < ActiveRecord::Migration
  def up
  	add_column :mailboxer_conversations, :blocked, :boolean, :default => false
  	add_column :mailboxer_conversations, :not_accept, :boolean, :default => false  	
  end

  def down
  end
end
