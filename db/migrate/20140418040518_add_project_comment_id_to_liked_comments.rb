class AddProjectCommentIdToLikedComments < ActiveRecord::Migration
  def change
    add_column :liked_comments, :project_comment_id, :integer
  end
end
