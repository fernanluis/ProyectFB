class ApplicationController < ActionController::Base
  # Permitir parámetros adicionale con devise
  # Dado que estamos utilizando Devise para manejar los procesos de registro e inicio de sesión,
  # a continuación, permitimos la recuperación de los parámetros fname, lname e image de nuestros
  # futuros formularios de creación del usuario.
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[fname lname image])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[fname lname image])
  end
end
