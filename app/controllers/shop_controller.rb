class ShopController < ApplicationController
  DEFAULT_PER_PAGE = ENV['DEFAULT_PER_PAGE'].to_i
  def index
    begin
      session[:off_set] = DEFAULT_PER_PAGE
      session[:prev_type_filter] = 'all'
      all_products = Product.where(is_actived: true).order(product_name: :ASC)
      @products = all_products.limit(DEFAULT_PER_PAGE)
      count_products = all_products.count
      get_product_filters
      @is_show_more = true
      @is_show_more = false if DEFAULT_PER_PAGE >= count_products
    rescue StandardError => e
      p e.message
      p e.backtrace
    end
  end
  private
  def get_product_filters
    @categories = Category.where(is_actived: true).order(category_name: :ASC)
    @ages = Age.where(is_actived: true).order(age_name: :ASC)
    @product_groups = ProductGroup.where(is_actived: true).order(product_group_name: :ASC)
    @events = Event.where(is_actived: true).order(event_name: :ASC)
  end
end
