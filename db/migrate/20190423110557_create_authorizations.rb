class CreateAuthorizations < ActiveRecord::Migration[5.2]
  def change
    create_table :authorizations do |t|
      t.string :provider, null: false
      t.string :uid, null: false
      t.references :user, foreign_key: true, index: true

      t.timestamps
    end

    add_index :authorizations, [:provider, :uid]
  end
end
