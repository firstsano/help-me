class AddIsBestToAnswers < ActiveRecord::Migration[5.2]
  def up
    add_column :answers, :is_best, :boolean
    change_column_default :answers, :is_best, false
  end

  def down
    remove_column :answers, :is_best
  end
end
