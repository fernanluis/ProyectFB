class CommentsController < ApplicationController
  # Dado que solo necesitamos poder crear comentarios y todos los comentarios
  # solo se podrán ver en la misma página que la publicación en la que se comentó.

  include AplicationHelper

  def new
    @comment = Comment.new
  end

  def create
    # Sigte.: valor del registro Post en el que se escribe este comentario en referencia.
    @post = Post.find(params[:comment][:post_id])
    # Sigte.: se almacena el valor de un nuevo registro de comentarios haciendo
    # referencia a la current_user como el propietario y el valor de retorno de comment_params.
    @comment = current_user.comments.build(comment_params)
    # # Una vez que el registro de comentarios se guarda y confirma con éxito en la base de datos.
    if @comment.save
    # Sigte.: se crea un nuevo registro de notificaciones utilizando el asistente de notificaciones
    # creado anteriormente en application_helper.rb.
      @notification = new_notification(@post.user, @post.id, 'comment') #
      @notification.save
    end
    redirect_to @post
  end

  def destroy
    @comment = Comment.find(params[:id])
    return unless current_user.id == @comment.user_id
    @comment.destroy
    flash[:success] ='Comment deleted'
    redirect_back(fallback_location: root_path)
    # redirect_back simplement actualiza la página actual.
  end


  private
  # A continuación: Un método que permite la recuperación de dos campos del formulario
  # utilizado para crear un comentario :content y :post_id.
  def comment_params
    params.require(:comment).permit(:content, :post_id)
  end

end
