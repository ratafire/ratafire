class ChangeSubRealmOfMajorposts < ActiveRecord::Migration
  def change
  	rename_column :majorposts, :realm, :category
  	rename_column :majorposts, :sub_realm, :sub_category
  end
end
