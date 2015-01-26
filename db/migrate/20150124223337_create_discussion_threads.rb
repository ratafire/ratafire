class CreateDiscussionThreads < ActiveRecord::Migration
  def change
    create_table :discussion_threads do |t|
      t.string :title
      t.text :excerpt
      t.text :content
      t.integer :user_id
      t.integer :thread_count
      t.integer :level, :default => 1
      t.string :slug
      t.boolean :published
      t.string :perlink
      t.string :edit_permission, :default => "free"
      t.datetime :deleted_at
      t.boolean :deleted, :default => false
      t.boolean :featured
      t.string :uuid
      t.boolean :test
      t.datetime :published_at
      t.datetime :commented_at
      t.boolean :early_access
      t.string :topic
      t.timestamps
    end
  end
end
