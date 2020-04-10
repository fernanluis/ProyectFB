class User < ApplicationRecord

  has_many :post
  has_many :comments
  has_many :likes, dependent: :destroy # inverso de asociación

  # Las líneas friend_sent.. y friend_request son las asociaciones inversas creadas para vincular
  # a las asociaciones sent_to y sent_by realizadas en el modelo de Amistad (app/models/friendship.rb).
  # Ver friendship.rb
  has_many :friend_sent, class_name: 'Friendship', # se declaran asociaciones bidireccionales.
                        foreign_key: 'sent_by_id',
                        inverse_of: 'sent_by',
                        dependent: :destroy # permitir que los registros relacionados con la asociación se destruyan independientemente del enlace asociativo.
  has_many :friend_request, class_name: 'Friendship', # se declaran asociaciones bidireccionales.
                        foreign_key: 'sent_to_id', # sent_to_id en ese registro será equivalente al User.id del usuario del que deseamos ver quién le envió todas las solicitudes de amistad.
                        inverse_of: 'sent_to',
                        dependent: :destroy # permitir que los registros relacionados con la asociación se destruyan independientemente del enlace asociativo.

  # se crea una asociación llamada friends, a través de la asociación realizada anteriormente friend_sent
  has_many :friends, -> { merge(Friendship.friends) },
           through: :friend_sent, source: :sent_to
           # sql generado:
           # SELECT "users".* FROM "users" INNER JOIN "friendships"
           # ON "users"."id" = "friendships"."sent_to_id"
           # WHERE "friendships"."sent_by_id" = $1 AND (status =TRUE) LIMIT $2

  has_many :pending_requests, -> { merge(Friendship.not_friends) },
           through: :friend_sent, source: :sent_to
           # sql generado:
           # SELECT "users".* FROM "users" INNER JOIN "friendships"
           # ON "users"."id" = "friendships"."sent_to_id"
           # WHERE "friendships"."sent_by_id" = $1 AND (status =FALSE) LIMIT $2

  has_many :received_requests, -> { merge(Friendship.not_friends) },
           through: :friend_request, source: :sent_by


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
