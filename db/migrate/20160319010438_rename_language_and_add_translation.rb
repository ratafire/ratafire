class RenameLanguageAndAddTranslation < ActiveRecord::Migration
  def up
    rename_column :users, :language, :locale
    rename_column :majorposts, :language, :locale
    rename_column :campaigns, :language, :locale
    rename_column :activities, :language, :locale
    rename_column :videos, :language, :locale
    rename_column :audios, :language, :locale
    change_column :users, :tagline, :string
    change_column :users, :fullname, :string
    change_column :users, :website, :string
    User.create_translation_table! :tagline => :string, :fullname => :string, :website => :string, :bio => :string, :firstname => :string, :lastname => :string, :preferred_name => :string
  end
  def down
  	User.drop_translation_table!
  end
end
