class LikesController < ApplicationController
  include ApplicationHelper

  def create
    type = type_subject?(params)[0]
    @subject = type_subject?(params)[1]
    notice_type = "like-#{type}"
    return unless @subject
    if already_like?(type)
      dislike(type)
    else
      @like = @subject.likes.build(user_id: current_user.id)
      if like.save
        flash[:success] = "#{type} liked"
        notification = new_notification(@subject.user, @subject.id, notice_type)
        @notification.save
      else
        flash[:danger] = "#{type} like filded"
      end
      redirect_back(fallback_location: root_path)
    end
  end

  private

  # recibe params de la ruta y determina si el id obtenido es la de un comentario o una publicación.
  # ver las rutas anidadas (create es accesible por dos rutas. ver app/config/routes.rb)
  def type_subject(params)
    type = 'post' if params.key?('posts')
    type = 'comment' if params.key?('comments')
    subject = Post.find(params[:post_id]) if type == 'post'
    subject = Comment.find(params[:comment_id]) if type == 'comment'
    [type, subject] # Después de decibir qué ruta usó, el método devuelve una matriz que contiene
                    # type (un valor de cadena de comentario o publicación) y
                    # asunto (el registro del comentario o publicación)
  end

  # devuelve un valor verdadero o falso que determina si existe un registro like
  # para la publicación o comentario en cuestión.
  def already_like(type)
    result = false
    if type == 'post'
      result = Like.where(user_id: current_user.id,
                          post_id: params[:post_id]).exists?
    end
    if type == 'comment'
      result Like.where(user_id: current_user.id,
                        comment_id: params[:comment_id]).exists?
    end
    result
  end

  # Básicamente el destroy del controlador like.
  # Encuentra el registro similar para la publicación o comenrtario
  # en función de la ruta anidada y lo destruye.
  def dislike(type)
    @like = Like.find_by(post_id: params[:post_id]) if type == 'post'
    @like = Like.find_by(comment_id: params[:comment_id]) if type == 'comment'

    return unless @like

    @like.destroy
    redirect_back(fallback_location: root_path)
  end
end
