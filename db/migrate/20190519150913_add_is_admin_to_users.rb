class AddIsAdminToUsers < ActiveRecord::Migration[5.2]
  def up
    add_column :users, :is_admin, :boolean
    change_column_default :users, :is_admin, false
  end

  def down
    remove_column :users, :is_admin
  end
end
