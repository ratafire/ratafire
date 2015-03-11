class AddChacheRateToProjects < ActiveRecord::Migration
  def change
    add_column :project_comments, :cached_votes_total, :integer, :default => 0
    add_column :project_comments, :cached_votes_score, :integer, :default => 0
    add_column :project_comments, :cached_votes_up, :integer, :default => 0
    add_column :project_comments, :cached_votes_down, :integer, :default => 0
    add_column :project_comments, :cached_weighted_score, :integer, :default => 0
    add_column :project_comments, :cached_weighted_total, :integer, :default => 0
    add_column :project_comments, :cached_weighted_average, :float, :default => 0.0
    add_index  :project_comments, :cached_votes_total
    add_index  :project_comments, :cached_votes_score
    add_index  :project_comments, :cached_votes_up
    add_index  :project_comments, :cached_votes_down
    add_index  :project_comments, :cached_weighted_score
    add_index  :project_comments, :cached_weighted_total
    add_index  :project_comments, :cached_weighted_average  	
  end
end
