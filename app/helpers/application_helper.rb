module ApplicationHelper
  # Dado que una notificación solo se creará como resultado de la
  # llamada a otra función de método y no tiene una vista real.
  # En lugar de crear un controlador, simplemente lo crearemos como un método auxiliar.

  # A continuación, simplemente se usará para crear un nuevo registro de notificación y
  # guardarlo en la Tabla de notificaciones .
  def new_notification(user, notice_id, notice_type)
    notice = user.notifications.build(notice_id: notice_id, notice_type: notice_type)
    user.notice_seen = false
    user.save
    notice
  end

  # A continuación, se usará para encontrar una publicación particular, comentario de solicitud
  # de amistad en función notice_id y notice_type
  # El notice_type determinará qué tabla investigar y buscar la notice_id dentro de esa tabla.
  def notification_find(notice, type)
    return User.find(notice.notice_id) if type == 'friendRequest'
    return Post.find(notice.notice_id) if type == 'comment'
    return Post.find(notice.notice_id) if type == 'like-post'
    return unless type == 'like-comment'
    comment = Comment.find(notice.notice_id)
    Post.find(comment.post_id)
  end

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


  # Dado que el controlador de Amistad depende de algunos métodos auxiliares,
  # los crearemos en la aplicación auxiliar.

  # Sgte.: método comprueba si un usuario ha tenido una solicitud de amistad
  # enviada por el usuario actual que devuelve true o false.
  def friend_request_sent?(user)
    current_user.friend_sent.exists?(sent_to_id: user.id, status: false)
  end

  # Sgte.: Este método comprueba si un usuario ha enviado una solicitud de amistad
  # al usuario actual que devuelve true o false.
  def friend_request_received?(user)
    current_user.friend_request.exists?(sent_by_id: user.id, status: false)
  end

  # Sigte.: el método comprueba si un usuario ha tenido una solicitud de amistad enviada
  # por el usuario actual o si el usuario actual ha enviado una solicitud de amistad.
  # Este método devuelve true o false
  def possible_friend?(user)
    request_sent = current_user.friend_sent.exists?(sent_to_id: user.id)
    request_received = current_user.friend_request.exists?(sent_by_id: user.id)

    return true if request_sent != request_received
    return true if request_sent == request_received && request_sent == true
    return false if request_sent == request_received && request_sent == false
  end
end
