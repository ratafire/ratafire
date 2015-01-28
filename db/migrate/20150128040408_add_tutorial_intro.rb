class AddTutorialIntro < ActiveRecord::Migration
  def up
  	add_column :tutorials, :intro, :integer
  end

  def down
  end
end
