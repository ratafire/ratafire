class AddRealmToManyThings < ActiveRecord::Migration
  def change
  	add_column :discussions, :realm, :string
  	add_column :discussions, :sub_realm, :string
  	add_column :projects, :sub_realm, :string
  	add_column :majorposts, :realm, :string
  	add_column :majorposts, :sub_realm, :string
  	add_column :discussion_threads, :realm, :string
  	add_column :discussion_threads, :sub_realm, :string
  	add_column :discussions, :creator_id, :integer
  	add_column :discussion_threads, :creator_id, :integer
  end
end
