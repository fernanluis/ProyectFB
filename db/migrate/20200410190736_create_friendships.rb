class CreateFriendships < ActiveRecord::Migration[6.0]
  def change
    create_table :friendships do |t|
      # {to_table: :users} la vincula a la tabla de usuarios.
      # reemplazo foreign_key: true
      t.references :sent_to, null: false, foreign_key: { to_table: :users }
      # reemplazo foreign_key: true
      t.references :sent_by, null: false,  foreign_key: { to_table: :users }
      t.boolean :status, default: false

      t.timestamps
    end
  end
end
# Originalmente, 'Foreign_key:' se habría establecido en 'true', pero en su lugar lo configuramos
#en 'Foreign_key: {to_table:: users}' vinculándolo a la tabla de usuarios.
