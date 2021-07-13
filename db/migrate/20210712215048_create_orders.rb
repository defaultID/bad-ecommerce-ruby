class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: { on_delete: :cascade }
      t.integer :status, limit: 1, unsigned: true, null: false, default: 0
      t.integer :payment_method, limit: 1, unsigned: true
      t.string :payment_id
      t.datetime :shipped_at, precision: 6
      t.datetime :received_at, precision: 6

      t.timestamps
    end
  end
end
