class CreateRecipients < ActiveRecord::Migration
  def change
    create_table :recipients do |t|
      t.integer :user_id
      t.string :recipient_id 
      t.string :object
      t.boolean :livemode
      t.string :klass
      t.timestamps
    end
  end
end
