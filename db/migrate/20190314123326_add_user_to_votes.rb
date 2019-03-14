class AddUserToVotes < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def change
    add_reference :votes, :user, foreign_key: true, index: false
    add_index :votes, :user_id, algorithm: :concurrently
  end
end
