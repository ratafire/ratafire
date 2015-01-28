class AddParentIdToDiscussion < ActiveRecord::Migration
  def change
  	add_column :discussion_threads, :parent_id, :integer
  end
end
