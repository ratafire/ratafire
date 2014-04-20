class CreateProjectComments < ActiveRecord::Migration
  def change
    create_table :project_comments do |t|
      t.text "content"
      t.integer "user_id"
      t.integer "project_id"
      t.text "excerpt"
      t.datetime "deleted_at"
      t.boolean "deleted", :default => false
      t.timestamps
    end
  end
end
