class CreateGithubs < ActiveRecord::Migration
  def change
    create_table :githubs do |t|

      t.timestamps
    end
  end
end
