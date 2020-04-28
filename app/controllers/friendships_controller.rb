class FriendshipsController < ApplicationController
  # rails generate controller Friendships create

  include ApplicationHelper

  # Dado que este método de creación del controlador de amistades es una ruta anidada bajo
  # el recurso de los usuarios, la ruta creada proporciona el parámetro user_id para usar
  # dentro de esta función.
  def create
    # Impide la posibilidad de enviarse una solicitud de amistad.
    return if current_user.id == params[:user_id]
    # Evita el envío de solicitudes de amistad más de una vez a la misma persona.
    return if friend_request_sent?(User.find(params[:user_id]))
    # Evita el envío de solicitudes de amistad a alguien que ya le envió una.
    return if friend_request_received?(User.find(params[:user_id]))

    # Dado que este método de creación del controlador de amistades es una ruta anidada
    # bajo el recurso de los usuarios, la ruta creada proporciona el parámetro user_id
    # para usar dentro de esta función.
    @user = User.find(params[:user_id])
    # crea un nuevo registro en la tabla de amistad que proporciona el valor de sent_by_id
    # como el del usuario actual utilizando la asociación friend_sent entre el modelo
    # de usuario y el modelo de amistad .
    @friendship = current_user.friend_sent.build(sent_to_id: params[:user_id])
    if @friendship.save
      # Una vez que el registro de Amistad se guarda con éxito,
      # se crea una nueva_notificación () y se vincula.
      flash[:success] = "Friend Request Sent!"
      @notification = new_notification(@user, current_user.id, 'friendRequest')
      @notification.save
    else
      flash[:danger] = "Friend Request Failed!"
    end
    redirect_back(fallback_location: root_path)
  end

  # actualiza el registro de amistad en la tabla de amistad estableciendo el
  # estado del registro en verdadero, que usamos para indicar que los usuarios son amigos.
  def accept_friend
    @friendship = Friendship.find_by(sent_by_id: params[:user_id],
                                      sent_to_id: current_user.id, status:false)
    return unless @friendship # devolver si no se encuentra ningún registro

    @friendship.status = true # record is update
    if @friendship.save # record is update and save
      flash[:success] = "Friend Request Accepted!"

      # Una vez que el registro original se actualiza y guarda, se crea un registro duplicado.
      # Este registro duplicado tendrá el valor inverso para sent_by_id y sent_to_id.
      # Esto hace que sea más fácil realizar tareas de amistad y verificaciones de
      # bases de datos para determinar listas de amigos.
      @friendship2 = current_user.friend_sent.build(sent_to_id: params[:user_id], status: true)
      @friendship2.save
    else
      flash[:danger] = "Friend Request could not be accepted!"
    end
    redirect_back(fallback_location: root_path)
  end
  # Por ejemplo, Pepe le envía a Moni una solicitud de amistad. Moni acepta la solicitud de amistad.
  # Al aceptar la solicitud de amistad, se realiza automáticamente otra solicitud de amistad.
  # Pero en cambio esta vez será como si Moni le hubiera enviado a Pepe una solicitud de amistad
  # y Pepe la hubiera aceptado.

  # Si un usuario rechaza una solicitud de amistad, el registro se elimina de la tabla de amistad.
  def decline_friend
    @friendship = Friendship.find_by(sent_by_id: params[:user_id], sent_to_id: current_user.id, status: false)
    return unless @friendship #  devolver si no se encuentra ningún registro

    @friendship.destroy
    flash[:success] = "Friend Request Declined!"
    redirect_back(fallback_location: root_path)
  end
end
