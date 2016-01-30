class DropPostimagesandProjectimages < ActiveRecord::Migration
  def up
    drop_table :postimages
    drop_table :projectimages
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
