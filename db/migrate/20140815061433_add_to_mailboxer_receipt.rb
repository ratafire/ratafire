class AddToMailboxerReceipt < ActiveRecord::Migration
  def up
  	add_column :mailboxer_receipts, :blocked, :boolean, :default => false
  	add_column :mailboxer_receipts, :not_accept, :boolean, :default => false
  end

  def down
  end
end
