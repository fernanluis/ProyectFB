class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user
  has_many :likes, dependent: :destroy # inverso de asociación
  validates :content, length: { in: 1..100 }, allow_blank: false
end
