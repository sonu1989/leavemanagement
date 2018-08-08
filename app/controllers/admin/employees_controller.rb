class Admin::EmployeesController < Admin::AuthenticationController
  
  def index
    if params[:search].present?
      term = params[:search]
      @employees = User.where.not(role: 'admin').where('first_name LIKE (?) or employee_id =?', "%#{term}%", term).paginate(:page => params[:page], :per_page => 5)
    elsif params[:employee_report] == 'true'
      @employees = User.includes(:balances).where.not(role: 'admin')
    else
      @employees = User.all_employees.paginate(:page => params[:page], :per_page => 10)
    end
    respond_to do |format|
      format.html
      format.csv { send_data @employees.to_csv, filename: "users.csv" }
    end
  end

  def new
    @employee = User.new
  end

  def create
    @employee = User.all_employees.new(user_params)
    if @employee.save
      redirect_to admin_employees_path
    else
      render 'new'
    end
  end

  def edit
    @employee = User.all_employees.find(params[:id])
  end

  def update
    @employee = User.find(params[:id])
    if @employee.update_attributes(user_params)
      redirect_to  admin_employees_path
    else
      render 'edit'
    end
  end

  def show
    @employee = User.find(params[:id])
  end

  def destroy
    @employee = User.all_employees.find(params[:id]) 
    @employee.update(deleted: true)
    @employee.leaves.update_all(deleted: true)
    redirect_to admin_employees_path
  end

  private
    def user_params
     params.require(:user).permit(:first_name, :last_name, :mobile,:role ,:email,:password,:manager_id)
    end
    
end
