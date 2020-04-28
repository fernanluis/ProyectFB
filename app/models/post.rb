class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy # inverso de asociación
  validates :content, length: { in: 3..800 }, allow_blank: false
end
