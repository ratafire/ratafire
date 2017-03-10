class CreateLevelXps < ActiveRecord::Migration
  def change
    create_table :level_xps do |t|
      t.integer :level
      t.integer :xp_to_levelup
      t.integer :majorpost
      t.integer :paid_post
      t.integer :get_backer
      t.integer :get_follower
      t.integer :post_media
      t.timestamps null: false
    end
  end
end
