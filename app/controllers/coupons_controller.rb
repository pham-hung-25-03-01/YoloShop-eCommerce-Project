class CouponsController < ApplicationController
  def index
    begin
      @coupons = Coupon.where(Arel.sql('DATE(start_date) <= current_date AND DATE(end_date) >= current_date AND number_of_uses > 0 AND is_actived = true'))
    rescue StandardError => e
      p e.message
      p e.backtrace
    end
  end
end
