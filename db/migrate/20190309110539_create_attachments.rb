class CreateAttachments < ActiveRecord::Migration[5.2]
  def change
    create_table :attachments do |t|
      t.string :source
      t.references :attachable, polymorphic: true

      t.timestamps
    end

    add_index :attachments, [:attachable_id, :attachable_type]
  end
end
