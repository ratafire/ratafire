class CreateOrganizationApplications < ActiveRecord::Migration
  def change
    create_table :organization_applications do |t|
    	t.string :name
    	t.integer :user_id
    	t.integer :step
    	t.text :collectible
    	t.text :about
    	t.string :location
      t.timestamps
    end
    add_attachment :organization_applications, :icon
    add_column :organizations, :collectible, :text
    add_column :organizations, :location, :string
  end
end
