class CreateRanks < ActiveRecord::Migration[6.1]
  def change
    create_table :ranks do |t|
      t.integer :score, null: false
      t.references :rankable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
