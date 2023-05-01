class CreateLinks < ActiveRecord::Migration[6.1]
  def change
    create_table :links do |t|
      t.string :title
      t.string :url,  null: false
      t.references :review, null: false, foreign_key: true

      t.timestamps
    end
  end
end
