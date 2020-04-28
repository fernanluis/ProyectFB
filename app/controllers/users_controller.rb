class UsersController < ApplicationController

  # Configuramos cuatro (4) variables de instancia, 3 de las cuales utilizan las asociaciones
  # que creamos dentro del modelo de Usuario.
  def index
    @users = User.all
    @friends = current_user.friends # reúne todos los registros de todos los amigos de este usuario.
# Sigte.: reúne todos los registros de los usuarios a los que este usuario ha enviado solicit. de amistad.
    @pending_requests = current_user.pending_requests
# Sigte.: reúne todos los registros de los usuarios que le han enviado a este usuario una solicitud de amistad.
    @friend_requests = current_user.received_requests
  end

  def show
    @user = User.find(params[:id])
  end

# El método update_img se usa para cambiar el archivo de imagen asociado con el registro de usuario.
# Un método simple y directo que recupera un registro User basado en el parámetro proporcionado :id.
  def update_img
    @user = User.find(params[:id])
    unless current_user.id == @user.id
      redirect_back(fallback_location: users_path(current_user))
      return
    end
# Se establece la columna de imagen del registro de Usuario a la imagen proporcionada por la route :image
    image = params[:user][:image] unless params[:user].nil?
    if image
      @user.image = image
      if @user.save # guarda el nuevo valor de imagen del registro .
        flash[:success] = "Image Uploaded"
      else
        flash[:danger] = "Image Uploaded Failed"
      end
    end
    redirect_back(fallback_location: root_path)
  end

end
