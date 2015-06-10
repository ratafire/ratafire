class ChangeTheMasspayBatchIdInErrors < ActiveRecord::Migration
  def up
  	remove_column :masspay_errors, :masspay_batches_id
  	add_column :masspay_errors, :masspay_batch_id, :integer
  end

  def down
  end
end
