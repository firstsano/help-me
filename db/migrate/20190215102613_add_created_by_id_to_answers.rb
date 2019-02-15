class AddCreatedByIdToAnswers < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def change
    add_column :answers, :created_by_id, :integer
    add_index :answers, :created_by_id, algorithm: :concurrently
    add_foreign_key :answers, :users, column: :created_by_id
  end
end
