class ReviewsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    if current_user.manager?
      @review_requests = current_user.review_requests.pending
    else
      @reviews = current_user.reviews.includes(:reviewer).where('created_at >?', Time.zone.now - 12.months).order('created_at DESC')
      if @reviews.size > 0
        @over_all_ratings = @reviews.map(&:rating).sum / @reviews.size
      end
    end
  end

  def new
    @review_request = ReviewRequest.find(params[:review_request_id])
    @review =  Review.new
  end

  def create
    @review_request = ReviewRequest.find(params[:review_request_id])
    @review =  Review.new(review_params)
    if @review.save
      @review_request.update_attributes(status: ReviewRequest.statuses[:complete])
      flash[:notice] = 'Feedback submitted successfully.'
      redirect_to reviews_path
    else
      render :new
    end
  end

  def show
    @review = Review.find(params[:id])
  end

  private
    def review_params
      params.require(:review).permit(:user_id, :reviewer_id, :feedback, :rating)
    end
end
