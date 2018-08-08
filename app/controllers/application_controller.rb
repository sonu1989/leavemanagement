class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden, content_type: 'text/html' }
      format.html { redirect_to root_path, notice: exception.message }
      format.js   { head :forbidden, content_type: 'text/html' }
    end
  end

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

end
