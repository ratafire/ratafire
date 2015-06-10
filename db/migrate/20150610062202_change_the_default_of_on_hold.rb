class ChangeTheDefaultOfOnHold < ActiveRecord::Migration
  def up
  	remove_column :masspay_batches, :on_hold
  	add_column :masspay_batches, :on_hold, :integer, :default => 0
  end

  def down
  end
end
