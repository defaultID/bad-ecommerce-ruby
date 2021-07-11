# frozen_string_literal: true

class CreateBaskets < ActiveRecord::Migration[6.1]
  def change
    create_table :baskets do |t|
      t.references :user, null: false, foreign_key: { on_delete: :cascade }
      t.references :product, null: false, foreign_key: { on_delete: :cascade }
      t.integer :count, null: false, default: 0, unsigned: true

      t.timestamps
      t.index %i[user_id product_id], unique: true
    end
  end
end
