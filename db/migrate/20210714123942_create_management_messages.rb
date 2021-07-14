class CreateManagementMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :management_messages do |t|
      t.references :user, null: true, foreign_key: { on_delete: :nullify }
      t.string :name
      t.string :email
      t.text :message

      t.timestamps
    end
  end
end
