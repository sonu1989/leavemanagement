class Admin::DashboardController < Admin::AuthenticationController
  before_action :authenticate_admin!

  def index
    @circulars = Circular.active
  end

  def edit
    @employee = User.employees.find(params[:id])
  end  

  
  def update
    @employee = User.find(params[:id])
    if @employee.update_attributes(user_params)
       redirect_to admin_dashboard_index_path
    else
      render 'edit'
    end
  end

  private
  def user_params
   params.require(:user).permit(:first_name, :last_name, :mobile,:role ,:email)
  end  
    
end
