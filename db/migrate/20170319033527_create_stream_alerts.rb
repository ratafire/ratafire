class CreateStreamAlerts < ActiveRecord::Migration
  def change
    create_table :stream_alerts do |t|
    	t.string :uuid
    	t.boolean :deleted
    	t.datetime :deleted_at
    	t.string :alert_type
    	t.string :image_href
    	t.string :sound_href
    	t.string :message
    	t.integer :duration
    	t.string :special_text_color
      t.integer :stream_labs_id
      t.integer :user_id
      t.timestamps null: false
    end
  end
end
