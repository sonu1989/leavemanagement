class WelcomeController < ApplicationController
  def index
    @circulars = Circular.active
  end
end
