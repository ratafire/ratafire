class AddSubRealmToActivities < ActiveRecord::Migration
  def change
  	add_column :activities, :sub_realm, :string
  end
end
