class AddProcessedToRewardUpload < ActiveRecord::Migration
  def change
  	add_column :reward_uploads, :processed,:boolean, default: false, null: false
  end
end
