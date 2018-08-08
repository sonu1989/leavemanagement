class Admin::HolidaysController < Admin::AuthenticationController

  def index
    @holidays = Holiday.order(:date)
  end 

  def new
    @holiday = Holiday.new
  end 
  def edit
    @holiday = Holiday.find(params[:id])
  end  

  def create
    @holiday = Holiday.new(holiday_params)
    if @holiday.save
      flash[:notice] = "New Holiday Successfully Created ."
      redirect_to admin_holidays_path    
    else
      render :new
    end    
  end

  def update
    @holiday = Holiday.find(params[:id])
    if @holiday.update_attributes(holiday_params)
      redirect_to  admin_holidays_path
    else
      render 'edit'
    end
  end
  
   def destroy
    @holiday = Holiday.find(params[:id]) 
    @holiday.destroy
    redirect_to admin_holidays_path
  end

  private 
    def holiday_params
      params.require(:holiday).permit(:date, :occasion)
    end
end
