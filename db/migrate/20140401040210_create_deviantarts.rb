class CreateDeviantarts < ActiveRecord::Migration
  def change
    create_table :deviantarts do |t|

      t.timestamps
    end
  end
end
