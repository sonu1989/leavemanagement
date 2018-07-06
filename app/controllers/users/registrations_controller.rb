class Users::RegistrationsController < Devise::RegistrationsController

  before_action :configure_permitted_parameters

  protected

  # my custom fields are :name, :heard_how
  def configure_permitted_parameters
    # devise_parameter_sanitizer.for(:account_update) do |u|
    #   u.permit(:name,
    #     :email, :password, :password_confirmation, :current_password)
    # end
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :heard_how,
        :email, :password, :password_confirmation, :first_name, :last_name, :mobile])
  end

end