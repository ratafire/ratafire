class AddTranslationToPartOfTheCampaign < ActiveRecord::Migration
  def change
  	Campaign.create_translation_table! :title => :string, :description => :string
  end
end
