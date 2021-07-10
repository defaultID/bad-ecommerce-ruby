class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.decimal :price, precision: 15, scale: 4, null: false
      t.text :description
      t.string :picture

      t.timestamps

      t.index :created_at
    end
  end
end
