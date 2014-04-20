class CreateVimeos < ActiveRecord::Migration
  def change
    create_table :vimeos do |t|

      t.timestamps
    end
  end
end
