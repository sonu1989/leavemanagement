class Admin::LeavesController < Admin::AuthenticationController
  before_action :set_employee, only: [:index, :create]

  def index
    if params[:search].present?
      @leaves = Leave.all.where('user_id =?',params[:search]).paginate(:page => params[:page], :per_page => 10)
    else  
      @leaves = Leave.all.order("created_at DESC").paginate(:page => params[:page], :per_page => 10)
    end  
  end
    
  def new
    @leave = Leave.new
  end
   
  def create
    @leave = Leave.new(leave_params)
    @leave.user =  current_user if leave_params[:user_id].blank?
    if @leave.save
      params[:leave][:days].each do |k,v|
        @leave.leave_days.create(date: v[:date] ,leave_type: v[:leave_type])
      end
      @leave.assign_start_end_date
      @leave.deduct_leave_balance
      @leave.send_notifications(current_user)
      flash[:notice] = "Leave placed successfully."   
      redirect_to admin_leaves_path
    else
      render :new
    end
  end

  def show
    @leave = Leave.find(params[:id])
  end

  def update
    @leave = Leave.find(params[:id])
    @leave.reason = params[:reason]
    @leave.status = params[:status]
    respond_to do |format|
      if @leave.save
        flash[:notice] = "You have #{@leave.status} #{@leave.user.user_name}'s leave request."
        format.js {}
      else
        format.js {render layout: false}
      end
    end
  end

  def destroy
    @leave = Leave.find(params[:id]) 
      @leave.destroy
    redirect_to admin_leaves_path
  end

  private 
    def leave_params
      params.require(:leave).permit(:description,:reason, :user_id, days: {})
    end
    
    def set_employee
      @user = User.find_by_id(params[:user_id])
    end
end
