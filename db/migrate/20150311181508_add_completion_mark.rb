class AddCompletionMark < ActiveRecord::Migration
  def up
  	add_column :subscription_applications, :completion, :boolean
  end

  def down
  end
end
