class AddCategoryToHistoricalQuotes < ActiveRecord::Migration
  def up
  	add_column :historical_quotes, :category, :string
  	HistoricalQuote.add_translation_fields! category: :string
  end
end
