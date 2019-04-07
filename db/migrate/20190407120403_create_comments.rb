class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.text :body, null: false
      t.references :user, foreign_key: true, index: true
      t.references :commentable, polymorphic: true
    end

    add_index :comments, [:commentable_id, :commentable_type]
  end
end
