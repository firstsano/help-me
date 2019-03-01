class BackfillAddIsBestToAnswers < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def change
    Answer.in_batches.update_all is_best: false
  end
end
