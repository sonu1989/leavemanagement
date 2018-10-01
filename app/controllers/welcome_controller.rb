class WelcomeController < ApplicationController
  def index
    @circular = Circular.find_circular
  end
end
