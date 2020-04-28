class AddLnameToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :lname, :string
  end
end
