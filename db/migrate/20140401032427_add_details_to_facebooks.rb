class AddDetailsToFacebooks < ActiveRecord::Migration
  def change
    add_column :facebooks, :user_birthday, :string
    add_column :facebooks, :email, :string
  end
end
