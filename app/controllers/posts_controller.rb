class PostsController < ApplicationController

  # El método index crea una variable de instancia que almacena el resultado del método creado
  # previamente en el modelo de usuario,'friends_and_own_posts' para recopilar todas
  # las publicaciones de este usuario y sus amigos.
  def index
    @our_posts = current_user.friends_and_own_posts
  end

  # El método show toma una publicación en particular dependiendo de la identificación proporcionada
  # por la ruta y la almacena en una variable de instancia llamada @post .
  def show
    @post = Post.find(params[:id])
  end

  # El new método crea un nuevo registro Post y lo asigna a la
  # variable @post pero no lo guarda.
  def new
    @post = Post.new
  end

  # El método create crea un nuevo registro Post, asignando el user_id de esa publicación
  # al del usuario actual que ha iniciado sesión (current_user es un dispositivo auxiliar incluido).
  def create
    # También crea la publicación utilizando los parámetros permitidos por el método posts_params
    @post = current_user.posts.build(posts_params)
    if @post.save
      # Si la publicación se creó y se guardó correctamente, el navegador redirigirá a la vista
      # de la página de la publicación creada.
      redirect_to @post
    else
      # Sin embargo, si la publicación no se pudo guardar, se mostrará la nueva vista de página de una
      # publicación (que será el formulario utilizado para crear una publicación).
      render "new"
    end
  end

  def destroy
    @post = Post.find(params[:id])
    return unless current_user.id == @post.user_id

    @post.destroy
    flash[:success] = 'Post deleted'
    redirect_back(fallback_location: root_path)
  end

  # El método posts_params se declara como un método privado (solo se puede acceder al método
  # dentro del archivo actual) que permite los parámetros :content y :imageURL proporcionados
  # por la ruta de creación de publicaciones que los devuelve en un formato Hash:
  # => <ActionController::Parameters {"content"=>"Example post", "imageURL"=>"http://example.com"} permitted: true>
  private

  def posts_params
    params.require(:post).permit(:content, :imageURL)
  end

end
