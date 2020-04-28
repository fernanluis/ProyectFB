class Like < ApplicationRecord
  belongs_to :user
  belongs_to :post, optional: true # permitiendo valores nulos para la clave foránea.
  belongs_to :comment, optional:true # permitiendo valores nulos para la clave foránea.
end
