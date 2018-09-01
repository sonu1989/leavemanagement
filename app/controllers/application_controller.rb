class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :no_sign_up

  def authenticate_admin!
    unless current_user.is_admin?    
      redirect_to new_user_session_path and return
    end 
  end

  
  protected
  
  def after_sign_in_path_for(resource)
    if current_user.is_admin?
      admin_dashboard_index_path
    else
      request.env['omniauth.origin'] || stored_location_for(resource) || root_path
    end
  end

  def no_sign_up
    if request.path == "/users/sign_up"
      redirect_to new_user_session_path and return
    end
  end

end
