class Notification < ApplicationRecord
  # rails generate model Notification notice_id:integer notice_type:string user:references
  belongs_to :user
  scope :friend_requests, -> { where('notice_type = friendRquest') }
  scope :likes, -> { where('notice_type = like') }
  scope :comments, -> { where('notice_type = comment') }
end


# notice_id: id post, comment, friendship request

# notice_type: string value record of Post Table, Comment Table or Friendship Table.

# The scopes created will allow us to single out notifications by type, e.g. Likes, ..
# ..comments or friend requests.

# This line creates two associations between Notification and Users.

# NO hay necesidad de un controlador de notificaciones, sin embargo, los métodos principales
# que se utilizaran para crear notificaciones serán creadas en la aplicación auxiliar. AplicationHelper
