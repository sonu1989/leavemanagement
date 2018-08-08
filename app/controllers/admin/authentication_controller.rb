class Admin::AuthenticationController < ApplicationController
  before_action :authenticate_user!
  before_action :check_auth
  
  layout 'admin'

  def check_auth
    if !(current_user.admin?)
      flash[:alert] = 'You are not authorize to access this page.'
      redirect_to root_path and return
    end
  end

end
