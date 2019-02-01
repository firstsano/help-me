class AddQuestionIdToAnswer < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def change
    add_reference :answers, :question, foreign_key: true, index: false
    add_index :answers, :question_id, algorithm: :concurrently
  end
end
