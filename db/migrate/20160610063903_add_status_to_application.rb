class AddStatusToApplication < ActiveRecord::Migration
  def change
  	add_column :campaigns, :status, :string
  	add_column :campaigns, :request_source, :string
  end
end
