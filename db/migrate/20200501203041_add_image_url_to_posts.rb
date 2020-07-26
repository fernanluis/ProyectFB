class AddImageUrlToPosts < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :imageURL, :string
  end
end
