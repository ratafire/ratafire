class CreateHistoricalQuotes < ActiveRecord::Migration
  def up
    create_table :historical_quotes do |t|
    	t.integer :user_id
    	t.datetime :deleted_at
    	t.boolean :deleted
    	t.text :quote
    	t.string :author
    	t.string :source
    	t.string :chapter
    	t.string :page
    	t.string :uuid
      t.timestamps null: false
    end
    HistoricalQuote.create_translation_table! :quote => :text, :author => :string, :source => :string
  end

  def down
  end
end
