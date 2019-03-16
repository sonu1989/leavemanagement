class Admin::LeavesController < Admin::AuthenticationController
  before_action :set_employee, only: [:index, :create]

  def index
    if params[:search].present?
      @leaves = Leave.where('employee_id =?',params[:search].to_i).paginate(:page => params[:page], :per_page => 10)
    else  
      @leaves = Leave.order("created_at DESC").paginate(:page => params[:page], :per_page => 10)
    end  
  end
    
  def new
    @leave = Leave.new
  end
   
  def create
    @leave = Leave.new(leave_params)
    @leave.user =  current_user if leave_params[:user_id].blank?
    @leave.placed_by =  current_user
    if @leave.save
      params[:leave][:days].each do |k,v|
        @leave.leave_days.create(date: v[:date] ,leave_type: v[:leave_type])
      end
      @leave.assign_start_end_date
      @leave.deduct_leave_balance
      @leave.send_notifications(current_user, 'create')
      flash[:notice] = "Leave placed successfully."   
      redirect_to admin_leaves_path
    else
      flash[:alert] = "#{@leave.errors.present? ? @leave.errors.full_messages.to_sentence : 'Select at least one date'}" 
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
    if params[:status]
      @leave.status_updated_by_id = current_user.id
    end
    respond_to do |format|
      if @leave.save
        @leave.send_notifications(current_user, 'update')
        flash[:notice] = "You have #{@leave.status} #{@leave.user.user_name}'s leave request."
        format.js {}
      else
        format.js {render layout: false}
      end
    end
  end

  def cancel
    @leave = Leave.find(params[:id])
    @leave.status = 'cancelled'
    @leave.status_updated_by_id = current_user.id
    if @leave.save
      @leave.send_notifications(current_user, 'cancel')
      @leave.update_balance_for_cancelled_leave
      flash[:notice] = "Your leave has been cancelled."
      redirect_to leaves_path
    else
      flash[:alert] = "Unable to cancel please try after sometime."
      redirect_to leaves_path
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
