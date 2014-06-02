class AddDeletedAtToBlogposts < ActiveRecord::Migration
  def change
    add_column :blogposts, :deleted_at, :datetime
  end
end
