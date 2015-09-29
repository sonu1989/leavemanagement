class LeavesController < ApplicationController
  before_action :authenticate_user!
  
  def index
    if current_user.user_type.eql?('employee')
      @leaves = current_user.leaves
    else
      @leaves = Leave.includes(:user).where("status = 'pending'")
    end
  end

  def new
    @leave = current_user.leaves.new
  end

  def create
    @leave = current_user.leaves.new(leave_params)
    if @leave.save
      flash[:notice] = "Your leave applied successfully."
      redirect_to leaves_path
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
    @leave.status = params[:status].present? ? 'rejected' : 'accepted'
    respond_to do |format|
      if @leave.save
        flash[:notice] = "You have #{@leave.status} #{@leave.user.user_name}'s leave request."
        format.js {}
      else
        format.js {render layout: false}
      end
    end
  end
  
  private 
    def leave_params
      params.require(:leave).permit(:start_date, :end_date, :description, :reason)
    end
end
