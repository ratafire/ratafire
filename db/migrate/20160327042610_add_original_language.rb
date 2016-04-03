class AddOriginalLanguage < ActiveRecord::Migration
  def up
  	add_column :historical_quotes, :original_language, :string
  	HistoricalQuote.add_translation_fields! original_language: :string
  end
end
