class AddIsBestIndexToAnswers < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def change
    add_index :answers, :is_best, algorithm: :concurrently
  end
end
