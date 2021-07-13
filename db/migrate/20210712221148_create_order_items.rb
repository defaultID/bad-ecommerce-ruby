class CreateOrderItems < ActiveRecord::Migration[6.1]
  def change
    create_table :order_items do |t|
      t.references :order, null: false, foreign_key: { on_delete: :cascade }
      t.references :product, null: true, foreign_key: { on_delete: :nullify }
      t.decimal :price, precision: 15, scale: 4, null: false
      t.integer :count, unsigned: true
    end
  end
end
