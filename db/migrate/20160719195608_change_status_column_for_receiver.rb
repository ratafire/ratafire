class ChangeStatusColumnForReceiver < ActiveRecord::Migration
  def change
  	change_column :reward_receivers, :status, :string
  end
end
