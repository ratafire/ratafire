class AddCountryCityToTranslation < ActiveRecord::Migration
  def up
    User.add_translation_fields! country: :string, city: :string
  end

  def down
  end
end
