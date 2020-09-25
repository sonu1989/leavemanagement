class Admin::ReviewsController < Admin::AuthenticationController
  
  def employees_list
    @employees =  User.includes(:reviews).where('users.role =?',User.roles['employee']).paginate(:page => params[:page], :per_page => 10)
  end

  def index
    @user = User.find(params[:employee_id])
    @reviews = @user.reviews.where(created_at: ((Time.zone.now - 12.months).end_of_day)..(Time.zone.now.beginning_of_day))
  end

  def show
    @review = Review.find(params[:id])    
  end

end
