class AddFnameToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :fname, :string
  end
end
