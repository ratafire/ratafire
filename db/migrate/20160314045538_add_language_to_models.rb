class AddLanguageToModels < ActiveRecord::Migration
  def change
  	add_column :users, :language, :string
  	add_column :majorposts, :language, :string
  	add_column :campaigns, :language, :string
  	add_column :activities, :language, :string
  	add_column :videos, :language, :string
  	add_column :audios, :language, :string
  end
end
