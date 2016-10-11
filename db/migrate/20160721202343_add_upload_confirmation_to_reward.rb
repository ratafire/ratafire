class AddUploadConfirmationToReward < ActiveRecord::Migration
  def change
  	add_column :rewards, :uploaded, :boolean
  	add_column :rewards, :uploaded_at, :datetime
  end
end
