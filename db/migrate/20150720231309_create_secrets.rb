class CreateSecrets < ActiveRecord::Migration
  def change
    create_table :secrets do |t|
      t.string :status
      t.integer :user_id
      t.string :title
      t.text :description
      t.string :location
      t.boolean :deleted
      t.datetime :deleted_at
      t.decimal :value, :precision => 10, :scale => 2, :default => 2
      t.string :category
      t.string :namecode
      t.timestamps
    end
  end
end
