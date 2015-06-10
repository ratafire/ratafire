class AddCorrelationToMasspayLog < ActiveRecord::Migration
  def change
  	add_column :masspay_logs, :correlation_id, :string
  end
end
