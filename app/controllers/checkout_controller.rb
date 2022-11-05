class CheckoutController < ApplicationController
  def index
    @inventories = Inventory.where(is_actived: true)
  end
end
