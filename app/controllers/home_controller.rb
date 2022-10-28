class HomeController < ApplicationController
  DEFAULT_PER_SECTION = ENV['DEFAULT_PER_SECTION'].to_i
  def index
    @new_arrival_products = Product.where(is_actived: true).order(created_at: :DESC).limit(DEFAULT_PER_SECTION)
    @featured_products = Product.where({inventories: Inventory.where({ order_details: OrderDetail.where(is_actived: true).distinct}).distinct, is_actived: true}, is_actived: true).limit(DEFAULT_PER_SECTION)
  end
end