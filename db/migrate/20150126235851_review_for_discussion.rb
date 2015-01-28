class ReviewForDiscussion < ActiveRecord::Migration
  def up
  	add_column :discussions, :review_status, :string,:default => "Pending"
  	add_column :discussions, :reviewed_at, :datetime
  end

  def down
  end
end
