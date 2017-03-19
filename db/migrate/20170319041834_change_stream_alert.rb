class ChangeStreamAlert < ActiveRecord::Migration
  def change
  	remove_column :stream_alerts, :stream_labs_id
  	add_column :stream_alerts, :stringlab_id, :integer
  	add_column :stream_alerts, :transaction_id, :integer
  	add_column :stream_alerts, :subscriber_id, :integer
  	add_column :stream_alerts, :amount, :integer
  	add_column :stream_alerts, :currency, :string
  	add_column :stream_alerts, :subscription_id, :integer
  	add_column :stream_alerts, :status, :string
  end
end
