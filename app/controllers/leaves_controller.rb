class LeavesController < ApplicationController
  before_action :authenticate_user!

  
  def index
    if current_user.manager?
      user_ids = current_user.employees.pluck(:id)
      user_ids << current_user.id
      @leaves = Leave.includes(:user).where('user_id IN (?)', user_ids).order("created_at DESC").paginate(:page => params[:page], :per_page => 10)
    else
      @leaves = current_user.leaves.includes(:user).order("created_at DESC").paginate(:page => params[:page], :per_page => 10)
    end
  end

  def new
    @leave = current_user.leaves.new
  end

  def create
    @leave = Leave.new(leave_params)
    @leave.user =  current_user if leave_params[:user_id].blank?
    if params[:leave][:days].present? && @leave.save
      params[:leave][:days].each do |k,v|
        @leave.leave_days.create(date: v[:date] ,leave_type: v[:leave_type])
      end
      @leave.assign_start_end_date
      @leave.deduct_leave_balance
      @leave.send_notifications(current_user)
      flash[:notice] = "Leave placed successfully."   
      redirect_to leaves_path
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
    @leave.status = params[:status].present? ? 'Approved' : 'Unapproved'
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
      params.require(:leave).permit(:description,:reason, :user_id, days: {})
    end
end
