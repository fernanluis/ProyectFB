class User < ApplicationRecord

  has_many :post
  has_many :comments
  has_many :likes, dependent: :destroy # inverso de asociación 

  # el método mount_uploader se agrega desde la gema carrierwave y el parámetro 'ImageUploader'
  # suministrado hace referencia al nombre del cargador que se generó. Se usa 'ImageUploader'
  # ya que generamos un cargador llamado image (app / uploaders / image_uploader.rb).
  mount_uploader :image, ImageUploader
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validate :picture_size # method into the validation requirements for the User model.

  private
    # Validates the size of an uploaded picture.
    def picture_size
      errors.add(:image, 'should be less than 1MB') if image.size > 1.megabytes
    end


end
