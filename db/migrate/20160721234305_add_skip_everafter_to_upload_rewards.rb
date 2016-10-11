class AddSkipEverafterToUploadRewards < ActiveRecord::Migration
  def change
  	remove_column :reward_uploads, :skip_ever_after
  	add_column :reward_uploads, :skip_everafter, :boolean
  end
end
