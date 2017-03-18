class AddStatusToEmail < ActiveRecord::Migration
  def change
  	add_column :emails, :status, :string
  end
end
