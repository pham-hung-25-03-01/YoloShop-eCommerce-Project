class ProductsController < ApplicationController
  def filter_by_categories
    category_name = params[:category]
    @products = Product.joins(:categories).where('products.is_actived = true AND categories.is_actived = true AND categories.category_name = ' + category_name)
    render json: @products
  end
end
