class AddProjectCommentIdToCommentimages < ActiveRecord::Migration
  def change
    add_column :commentimages, :project_comment_id, :integer
  end
end
