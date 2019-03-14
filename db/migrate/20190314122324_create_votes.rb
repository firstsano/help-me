class CreateVotes < ActiveRecord::Migration[5.2]
  def change
    create_table :votes do |t|
      t.integer :value, default: 1, null: false
      t.references :votable, polymorphic: true

      t.timestamps
    end

    safety_assured do
      reversible do |migration|
        migration.up do
          execute <<-SQL
            ALTER TABLE votes
              ADD CONSTRAINT vote_value
                CHECK (value IN (1, -1));
          SQL
        end
        migration.down do
          execute <<-SQL
            ALTER TABLE votes
              DROP CONSTRAINT vote_value
          SQL
        end
      end
    end

    add_index :votes, [:votable_id, :votable_type]
  end
end
