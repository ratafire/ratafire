class AddAMailerMessageToSecret < ActiveRecord::Migration
  def change
  	add_column :secrets, :mailer_message, :text
  end
end
