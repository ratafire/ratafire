class AddPreferredNameToUser < ActiveRecord::Migration
  def change
    remove_column :users, :profilelarge_file_name
    remove_column :users, :profilelarge_content_type
    remove_column :users, :profilelarge_file_size
    remove_column :users, :profilelarge_updated_at
    remove_column :users, :profilemedium_file_name
    remove_column :users, :profilemedium_content_type
    remove_column :users, :profilemedium_file_size
    remove_column :users, :profilemedium_updated_at
    remove_column :users, :why
    remove_column :users, :plan
    remove_column :users, :amazon_authorized
    remove_column :users, :invitation_token
    remove_column :users, :invitation_created_at
    remove_column :users, :invitation_sent_at
    remove_column :users, :invitation_accepted_at
    remove_column :users, :invitation_limit
    remove_column :users, :invited_by_id
    remove_column :users, :invited_by_type
    remove_column :users, :invitations_count
    remove_column :users, :supporter_slot
    remove_column :users, :amount_display_switch
    remove_column :users, :ssn
    remove_column :users, :need_username
    remove_column :users, :after_subscription_url
    remove_column :users, :accept_venmo
    remove_column :users, :organization_id
    remove_column :users, :organization_leader_id
    remove_column :users, :masked
    add_column :users, :preferred_name, :string
  end
end
