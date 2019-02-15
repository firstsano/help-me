class AddCreatedByIdToQuestions < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def change
    add_column :questions, :created_by_id, :integer
    add_index :questions, :created_by_id, algorithm: :concurrently
    add_foreign_key :questions, :users, column: :created_by_id
  end
end
