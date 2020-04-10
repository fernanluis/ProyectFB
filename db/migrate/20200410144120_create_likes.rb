class CreateLikes < ActiveRecord::Migration[6.0]
  def change
    create_table :likes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :post, null: true, foreign_key: true # estableciendo parámetro nulo, de null: false a true
      t.references :comment, null: true, foreign_key: true # estableciendo parámetro nulo, de null: false a true

      t.timestamps
    end
  end
end
