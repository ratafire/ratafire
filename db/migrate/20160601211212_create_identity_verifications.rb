class CreateIdentityVerifications < ActiveRecord::Migration
  def change
    create_table :identity_verifications do |t|
    	t.string :ssn
    	t.string :encrypted_ssn
    	t.string :passport
    	t.string :encrypted_passport
    	t.string :drivers_licence
    	t.string :encrypted_drivers_licence
    	t.string :id_card
    	t.string :encrypted_id_card
    	t.integer :user_id
    	t.string :birthday
    	t.string :state
    	t.string :address
    	t.string :city
    	t.string :apartment
    	t.string :address_zip
    	t.string :country
    	t.boolean :deleted
    	t.datetime :deleted_at
      t.timestamps null: false
    end
    add_attachment :identity_verifications, :identity_document
  end
end
