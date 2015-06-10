class CreateMasspayLogs < ActiveRecord::Migration
  def change
    create_table :masspay_logs do |t|
    	t.boolean :deleted
    	t.datetime :deleted_at
    	t.decimal :amount, :default => 0, :precision => 10, :scale => 2
    	t.integer :count, :default => 0
      t.timestamps
    end
  end
end
