class ChangeColumnNameOfSupporter < ActiveRecord::Migration
  def up
  	rename_column :subscriptions, :supporter, :supporter_switch
  	rename_column :transactions, :supporter, :supporter_switch
  	rename_column :subscription_records, :supporter, :supporter_switch
  end

  def down
  end
end
