class LikesController < ApplicationController
  # rails generate controller Likes create
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
        flash[:danger] = "#{type} like filded!"
      end
      redirect_back(fallback_location: root_path)
    end
  end

  private

  # Sigte.: recibe params de la ruta y determina si el id obtenido es la de un comemnt o una post.
  # los cuales ofrecen un parámetro diferente.
  def type_subject?(params)
    type = 'post' if params.key?('posts_id') # qué ruta usó?.. y devuelve una matriz de type:'post'?
    type = 'comment' if params.key?('comments_id') # qué ruta usó?.. y devuelve una matriz de type: 'comment'?
    subject = Post.find(params[:post_id]) if type == 'post' # qué ruta usó?.. y devuelve un asunto, el registro de post
    subject = Comment.find(params[:comment_id]) if type == 'comment' # # qué ruta usó?.. y devuelve un asunto, el registro de comment
    [type, subject] # Después de decibir qué ruta usó, el método devuelve una matriz que contiene
                    # type (un valor de cadena de comentario o publicación) y
                    # asunto (el registro del comentario o publicación)
  end

  # Sigte.: devuelve un valor verdadero o falso que determina si existe un registro like
  # para la publicación o comentario en cuestión.
  def already_like?(type) # ya le ha gustado?
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
  def dislike(type) # método disgusto
    # Encuentra el registro similar para la publicación o comenrtario.
    # en función de la ruta anidada y lo destruye.
    @like = Like.find_by(post_id: params[:post_id]) if type == 'post'
    @like = Like.find_by(comment_id: params[:comment_id]) if type == 'comment'

    return unless @like
    @like.destroy
    redirect_back(fallback_location: root_path)
  end
end
