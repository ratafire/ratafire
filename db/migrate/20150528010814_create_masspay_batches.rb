class CreateMasspayBatches < ActiveRecord::Migration
  def change
    create_table :masspay_batches do |t|
    	t.boolean :deleted
    	t.datetime :deleted_at
    	t.boolean :transfered
    	t.datetime :transfered_at
    	t.text :complete_response
    	t.text :error_short_message
    	t.text :error_long_message
    	t.string :error_code
    	t.string :ack
    	t.string :correlation_id
    	t.boolean :error
    	t.decimal :amount, :default => 0, :precision => 10, :scale => 2
    	t.decimal :fee, :default => 0, :precision => 10, :scale => 2
    	t.decimal :receive, :default => 0, :precision => 10, :scale => 2
    	t.boolean :on_hold
    	t.timestamps
    end

    add_column :transfers, :masspay_batch_id, :integer

  end
end
