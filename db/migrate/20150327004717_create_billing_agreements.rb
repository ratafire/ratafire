class CreateBillingAgreements < ActiveRecord::Migration
  def change
    create_table :billing_agreements do |t|
      t.integer :user_id
      t.string :billing_agreement_id
      t.string :status
      t.boolean :deleted
      t.datetime :deleted_at
      t.timestamps
    end
  end
end
