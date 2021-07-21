class AddLockedFlagToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :locked, :boolean, after: :admin, null: false, default: false
  end
end
