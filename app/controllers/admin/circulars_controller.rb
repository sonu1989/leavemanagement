class Admin::CircularsController < Admin::AuthenticationController

  before_action :set_circular, expect: [:new, :create]

  def index
    @circulars = Circular.all
  end 
  
  def create
    @circular = Circular.new(circular_params)
    if @circular.save
      flash[:notice] = "New Circular Successfully Created."
      redirect_to admin_circulars_path
    else
      render 'new'
    end
  end
  def new
    @circular = Circular.new 
  end 

  def edit;end

  def show;end

  def update
    if @circular.update_attributes(circular_params)
      redirect_to  admin_circulars_path
    else
      render 'edit'
    end
  end

  def destroy
    @circular.destroy
    redirect_to admin_circulars_path
  end 


  def update_published
    @circular.published = params[:published]
    if @circular.save
      redirect_to admin_circulars_path
    end
  end 

  private 
    def circular_params
      params.require(:circular).permit(:note, :published_at, :published)
    end

    def set_circular
      @circular = Circular.find_by_id(params[:id])
    end
end
