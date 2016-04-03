class AddChapterTranslationToHistoricalQuotes < ActiveRecord::Migration
  def change
  	HistoricalQuote.add_translation_fields! chapter: :string
  end
end
