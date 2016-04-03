class AddJobTitleToUser < ActiveRecord::Migration
  def up
  	add_column :users, :job_title, :string
  	User.add_translation_fields! job_title: :string
  end
end
