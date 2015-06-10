class CreateMasspayErrors < ActiveRecord::Migration
  def change
    create_table :masspay_errors do |t|
      t.integer :masspay_batches_id
      t.string :error_code
      t.text :error_long_message
      t.string :error_short_message
      t.boolean :corrected
      t.datetime :corrected_at
      t.boolean :deteled
      t.datetime :deleted_at
      t.timestamps
    end
  end
end
