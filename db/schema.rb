# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_07_10_232643) do

  create_table "baskets", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "product_id", null: false
    t.integer "count", default: 0, null: false, unsigned: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["product_id"], name: "index_baskets_on_product_id"
    t.index ["user_id", "product_id"], name: "index_baskets_on_user_id_and_product_id", unique: true
    t.index ["user_id"], name: "index_baskets_on_user_id"
  end

  create_table "products", charset: "utf8mb4", force: :cascade do |t|
    t.string "name", null: false
    t.decimal "price", precision: 15, scale: 4, null: false
    t.text "description"
    t.string "picture"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["created_at"], name: "index_products_on_created_at"
  end

  create_table "users", charset: "utf8mb4", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "email", null: false
    t.string "encrypted_password", limit: 128, null: false
    t.string "api_token", limit: 128, null: false
    t.string "full_name"
    t.string "address"
    t.string "city"
    t.string "country_code", limit: 2
    t.boolean "admin", default: false, null: false
    t.index ["api_token"], name: "index_users_on_api_token"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "baskets", "products", on_delete: :cascade
  add_foreign_key "baskets", "users", on_delete: :cascade
end
