class UsersController < ApplicationController

  def index
    @users = User.all
    @friends = current_user.friends
    @pending_requests = current_user.pending_requests
    @friend_requests = current_user.received_requests
  end

  def show
    @user = User.find(params[:id])
  end

  def update_img
    @user = User.find(params[:id])
    unless current_user.id == @user.id
      redirect_back(fallback_location: users_path(current_user))
      return
    end

# Se establece la columna de imagen del registro de Usuario
# a la imagen proporcionada por la route :image
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
