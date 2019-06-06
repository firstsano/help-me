class CreateQuestionSubscriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :question_subscriptions do |t|
      t.references :question, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end

    add_index :question_subscriptions, [:question_id, :user_id], unique: true
  end
end
