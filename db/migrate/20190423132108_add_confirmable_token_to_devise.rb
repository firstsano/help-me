class AddConfirmableTokenToDevise < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def change
    add_index :users, :confirmation_token, unique: true, algorithm: :concurrently
  end
end
