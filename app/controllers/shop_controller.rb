class ShopController < ApplicationController
  def index
    @products = Product.where(is_actived: true).order(product_name: :ASC)
    get_product_filters
  end
  private
  def get_product_filters
    @categories = Category.where(is_actived: true).order(category_name: :ASC)
    @ages = Age.where(is_actived: true).order(age_name: :ASC)
    @product_groups = ProductGroup.where(is_actived: true).order(product_groups: :ASC)
  end
end
