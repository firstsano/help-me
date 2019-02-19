class RemoveTitleColumnFromAnswers < ActiveRecord::Migration[5.2]
  def change
    safety_assured { remove_column :answers, :title, :string }
  end
end
