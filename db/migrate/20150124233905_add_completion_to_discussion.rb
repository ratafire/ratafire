class AddCompletionToDiscussion < ActiveRecord::Migration
  def change
  	add_column :discussions, :complete, :boolean, :default => false
  	add_column :discussion_threads, :complete, :boolean, :default => false
  end
end
