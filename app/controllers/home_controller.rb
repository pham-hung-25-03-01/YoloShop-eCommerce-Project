class HomeController < ApplicationController
  def index
    @products = Product.where('is_actived = true')
  end
end
