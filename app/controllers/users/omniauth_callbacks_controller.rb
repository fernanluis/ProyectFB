class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    #raise request.env["omniauth.auth"].to_yaml
    @user = User.from_omniauth(request.env["omniauth.auth"])
    if @user.persisted?
      #@user.remember_me = true #sesión persistente a pesar de cerrar el navegador.
      sign_in_and_redirect @user, event: :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, kind: "Facebook") if is_navigational_format?
    else
      #session["devise.auth"] = request.env["omniauth.auth"]
      #render :edit
      session["devise.facebook_data"] = request.env["omniauth.auth"].except(:extra) # Removing extra as it can overflow some session stores
      redirect_to new_user_registration_url
    end
  end

  def failure
#   redirect_to new_user_session_path, notice: "Hubo un error con el login, intenta denuevo." comentamos y pasamos parámetros del protocolo omniauth
#   redirect_to new_user_session_path, notice: "No pudimos loguearte"#. Error: #{params[:error_description]}. Motivo: #{params[:error_reason]}"
    redirect_to root_path, notice: "No pudimos loguearte"#. Error: #{params[:error_description]}. Motivo: #{params[:error_reason]}"
  end

end
