class AddStreamlabIdToStreamAlert < ActiveRecord::Migration
  def change
  	add_column :stream_alerts, :streamlab_id, :integer
  end
end
