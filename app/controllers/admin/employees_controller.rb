class Admin::EmployeesController < Admin::AuthenticationController
  
  def index
    if params[:search].present?
      term = params[:search]
      @employees = User.where.not(role: 'admin').where('email LIKE ? or employee_id =? or first_name LIKE ?', "%#{term}%", term.to_i, "%#{term}%").paginate(:page => params[:page], :per_page => 5)
    else
      @employees = User.all_employees.order('employee_id ASC').paginate(:page => params[:page], :per_page => 10)
    end
  end

  def new
    @employee = User.new
  end

  def create
    @employee = User.all_employees.new(user_params)
    if @employee.save
      @employee.add_leave_balance
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

  def generate_csv
    @employees = User.includes(:balances).where.not(role: "admin").order('employee_id ASC')
    respond_to do |format|
      format.html { send_data @employees.to_csv(params[:month]), filename: "Team Members Leave Report - #{Time.zone.now.strftime('%d/%m/%Y, %I:%M %p')}.csv" }
    end
  end 

  private
    def user_params
     params.require(:user).permit(:first_name, :last_name, :mobile,:role ,:email,:password,:manager_id, :joining_date, :image)
    end
    
end
