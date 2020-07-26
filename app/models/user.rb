class User < ApplicationRecord

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy # inverso de asociación. Permite eliminar registros de la tabla like sin errores de asociación SQL.
  has_many :notifications, dependent: :destroy # inverso de asociación

  # Las líneas friend_sent.. y friend_request son las ASOCIACIONES INVERSAS creadas para vincular
  # a las asociaciones sent_to y sent_by realizadas en el modelo de Amistad (app/models/friendship.rb).
  # Ver friendship.rb
  # AMISTAD ENVIADA. Se declaran asociaciones bidireccionales.
  has_many :friend_sent, class_name: 'Friendship',
  # clave foránea a la que está vinculada ésta asociación dentro de la tabla Amistad.
                        foreign_key: 'sent_by_id',
  # nombre de la asociación creada en el modelo Friendship
                        inverse_of: 'sent_by',
  # permitir que los registros relacionados con la asociación se destruyan independientemente del enlace asociativo.
                        dependent: :destroy
  has_many :friend_request, class_name: 'Friendship', # SOLICITUD DE AMISTAD. Se declaran asociaciones bidireccionales.
                        foreign_key: 'sent_to_id', # sent_to_id en ese registro será equivalente al User.id del usuario del que deseamos ver quién le envió todas las solicitudes de amistad.
                        inverse_of: 'sent_to', # nombre de la asociación crada en el modelo Friendship
                        dependent: :destroy # permitir que los registros relacionados con la asociación se destruyan independientemente del enlace asociativo.

  # se crea una asociación llamada friends, a través de la asociación realizada
  # anteriormente friend_sent
  has_many :friends, -> { merge(Friendship.friends) }, # con status de amistad = TRUE
           through: :friend_sent, source: :sent_to
           # sql generado:
           # SELECT "users".* FROM "users" INNER JOIN (unir internamente) "friendships"
           # ON "users"."id" = "friendships"."sent_to_id"
           # WHERE "friendships"."sent_by_id" = $1 AND (status =""""""TRUE""""") LIMIT $2
# el sent_by_id será equivalente al User.id del usuario del que desemos saber quiénes son todos sus amigos.
           # Registros de todos los usuarios considerados amigos del usuario actual .
  has_many :pending_requests, -> { merge(Friendship.not_friends) }, # con status de amistad = FALSE
           through: :friend_sent, source: :sent_to
           # sql generado:
           # SELECT "users".* FROM "users" INNER JOIN "friendships"
           # ON "users"."id" = "friendships"."sent_to_id"
           # WHERE "friendships"."sent_by_id" = $1 AND (status =FALSE) LIMIT $2
           # el sent_by_id será equivalente al User.id del usuario del que desemos saber a quién le envió todas las solicitudes de amistad.
           # Esta asociación devuelve los usuarios que han recibido solicitudes de amistad del usuario elegido.
  has_many :received_requests, -> { merge(Friendship.not_friends) },
           through: :friend_request, source: :sent_by
           # SELECT "users".* FROM "users" INNER JOIN "friendships"
           # ON "users"."id" = "friendships"."sent_by_id"
           # WHERE "friendships"."sent_to_id" = $1 AND (status =FALSE) LIMIT $2
           # (lo que significa que los dos usuarios no están en una amistad mutua )
           # El "sent_to_id" en ese registro será equivalente al User.id del usuario del
           # que deseamos ver quién le envió todas las solicitudes de amistad.
           # Por lo tanto, esta asociación devuelve los usuarios que han enviado
           # solicitudes de amistad a un usuario elegido.

  # el método mount_uploader se agrega desde la gema carrierwave y el parámetro 'ImageUploader'
  # suministrado hace referencia al nombre del cargador que se generó.
  mount_uploader :image, ImageUploader # Aquí montamos el cargador de imágenes creado.

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         #:omniauthable, :omniauth_providers => [:facebook]
         :omniauthable, omniauth_providers: %i[facebook]

  def self.from_omniauth(auth)
    #where(provider: auth[:provider], uid: auth[:uid]).first_or_create do |user|
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      #if auth[:info]
      #user.email = auth[:info][:email]
      #user.fname = auth[:info][:fname]
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.fname = auth.info.first_name   # assuming the user model has a name
      user.lname = auth.info.last_name # assuming the user model has a last name
      user.image = auth.info.image # assuming the user model has an image
      # If you are using confirmable and the provider(s) you use validate emails,
      # uncomment the line below to skip the confirmation emails.
      # user.skip_confirmation!
    end
    #user.password = Devise.friendly_token[0, 20]

  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  validate :picture_size # requisitos de validación para el modelo de Usuario.

  # A continuación, simplemente devuelve una cadena que concatena tanto para el usuario de fname y lname.
  def full_name
    "#{fname} #{lname}"
  end

  # El método friends_and_own_posts devuelve todas las publicaciones de todos
  # los amigos del usuario junto con la publicación del usuario.
  def friends_and_own_posts
    myfriends = friends # es una matriz que se completa utilizando la asociación 'has_many: friends'
                        # que devuelve todos los registros de los amigos del usuario.
    our_posts = [] # las publicaciones de cada uno de los amigos junto con las propias
                   # publicaciones del usuario se insertan en 'our_posts'.
    myfriends.each do |f|
      f.posts.each do |p|
        our_posts << p
      end
    end

    posts.each do |p|
      our_posts << p
    end
    our_posts
  end

  private
    # A continuación: evuelve un error si la imagen cargada es mayor a 1 megabyte.
    def picture_size
      errors.add(:image, 'should be less than 1MB') if image.size > 1.megabytes
    end


end
