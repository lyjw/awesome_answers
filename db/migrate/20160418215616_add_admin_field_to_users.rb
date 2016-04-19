class AddAdminFieldToUsers < ActiveRecord::Migration
  def change
    # No Admin by default
    add_column :users, :admin, :boolean, default: false
  end
end
