class CreateStats < ActiveRecord::Migration[6.1]
  def change
    create_table :stats do |t|
      t.integer :views, null: false, default: 0
      t.integer :ranks_count, null: false, default: 0
      t.float :rank_avg, null: false, default: 0
      t.references :statable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
