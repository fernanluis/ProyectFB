module ApplicationHelper
  # Returns the new record created in notifications table
  def new_notification(user, notice_id, notice_type)
    notice = user.notifications.build(notice_id: notice_id, notice_type: notice_type) # crea un nuevo registro de notificación y lo guarda en la tabla de notificaciones.
    user.notice_seen = false
    user.save
    notice
  end

  # Receives the notification object as parameter along with a type
  # and returns a User record, Post record or a Comment record
  # depending on the type supplied
  def notification_find(notice, type)
    return User.find(notice.notice_id) if type == 'friendRequest'
    return Post.find(notice.notice_id) if type == 'comment'
    return Post.find(notice.notice_id) if type == 'like-post'
    return unless type == 'like-comment'
    comment = Comment.find(notice.notice_id)
    Post.find(comment.post_id)
  end

# Dado que una notificación solo se creará como resultado de la
# llamada a otra función de método y no tiene una vista real.
# En lugar de crear un controlador, simplemente lo crearemos como un método auxiliar.

  # Checks whether a post or comment has already been liked by the
  # current user returning either true or false
  # Similar to the already_liked method in the Likes controller, the liked?(subject, type)
  # method takes two arguments. A record object, subject and the string literal of its type.
  def liked?(subject, type)
    result = false
    result = Like.where(user_id: current_user.id, post_id:
                        subject.id).exists? if type == 'post'
    result = Like.where(user_id: current_user.id,comment_id:
                        subject.id).exists? if type == 'comment'
    result
  end
end
