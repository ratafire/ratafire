class CreateTutorials < ActiveRecord::Migration
  def change
    create_table :tutorials do |t|
      t.integer :user_id
      t.integer :profile_tutorial
      t.timestamps
    end
  end
end
