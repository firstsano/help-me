class BackfillAddIsAdminToUsers < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def change
    User.in_batches.update_all is_admin: false
  end
end
