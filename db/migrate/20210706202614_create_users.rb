class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.timestamps null: false
      t.string :email, null: false
      t.string :encrypted_password, limit: 128, null: false
      t.string :api_token, limit: 128, null: false
      t.string :full_name
      t.string :address
      t.string :city
      t.string :country_code, limit: 2
    end

    add_index :users, :email, unique: true
    add_index :users, :api_token
  end
end
