require 'securerandom'
class CheckoutController < ApplicationController
  skip_before_action :verify_authenticity_token
  def index
    begin
      @inventories = Inventory.where(is_actived: true)
    rescue StandardError => e
      p e.message
      p e.backtrace
    end
  end
  def proceed_to_checkout
    begin
      if user_signed_in?
        count_user_cart = Cart.where(user_id: current_user.id).count
        if count_user_cart > 0
          @payments = Payment.where(is_actived: true)
          render json: { html: render_to_string(partial: 'layouts/partials/confirm_order_information', locals: {payments: @payments}), is_signed_in: true, is_cart_empty: false }
        else
          render json: { is_signed_in: true, is_cart_empty: true }
        end
      else
        render json: { is_signed_in: false }
      end
    rescue StandardError => e
      p e.message
      p e.backtrace
    end
  end
  def back_to_cart
    begin
      if user_signed_in?
        @inventories = Inventory.where(is_actived: true)
        render json: { html: render_to_string(partial: 'layouts/partials/update_cart', locals: {carts: @carts, inventories: @inventories}), is_signed_in: true }
      else
        render json: { is_signed_in: false }
      end
    rescue StandardError => e
      p e.message
      p e.backtrace
    end
  end
  def apply_coupon
    begin
      if user_signed_in?
        coupon = Coupon.find_by(id: params[:coupon][:id], is_actived: true)
        session[:coupon] = coupon
        return render json: { is_signed_in: true, discount: 0, total_payment: session[:total_cart], is_available: false } if coupon.nil? || coupon.start_date.to_date > Time.now.to_date || coupon.end_date.to_date < Time.now.to_date || coupon.number_of_uses < 1
        discount = session[:total_cart] * coupon.coupon_discount / 100
        total_payment = session[:total_cart] - discount
        render json: { is_signed_in: true, discount: discount, total_payment: total_payment, is_available: true }
      else
        render json: { is_signed_in: false }
      end
    rescue StandardError => e
      p e.message
      p e.backtrace
    end
  end
  def pay
    begin
      if user_signed_in?
        return render json: {is_signed_in: true, is_error: true } if params[:order_info][:apartment_number].strip.empty? || params[:order_info][:street].strip.empty? || params[:order_info][:ward].strip.empty? || params[:order_info][:district].strip.empty? || params[:order_info][:province].strip.empty? || params[:order_info][:payment].strip.empty?
        order = Order.new(id: SecureRandom.uuid, user_id: current_user.id, apartment_number: params[:order_info][:apartment_number], street: params[:order_info][:street], ward: params[:order_info][:ward], district: params[:order_info][:district], province: params[:order_info][:province], status: 0, updated_by: current_user.id, is_actived: true)
        session[:order] = order
        payment_url = params[:order_info][:payment].to_s.eql?(ENV['VNPAY_E_WALLET_PAYMENT_ID'].to_s) ? get_payment_url(order) : ENV['CHECKOUT_RESULT_URL']
        render json: {is_signed_in: true, is_error: false, payment_url: payment_url }
      else
        render json: { is_signed_in: false }
      end
    rescue StandardError => e
      p e.message
      p e.backtrace
    end
  end
 
  private
  def get_payment_url(order_object)
    vnp_hash_secret = ENV['VNP_HASH_SECRET']
    vnp_url = ENV['VNP_URL']
    vnp_txnref = order_object.id
    vnp_order_info = ENV['VNP_ORDER_INFO']
    coupon = session[:coupon].nil? ? 0 :  session[:coupon]['coupon_discount']
    vnp_amount = (session[:total_cart] * (1 - coupon / 100) * 100).to_i.to_s
    vnp_ipadd = request.remote_ip

    input_data = {
      'vnp_Amount' => vnp_amount,
      'vnp_Command' => ENV['VNP_COMMAND'],
      'vnp_CreateDate' => DateTime.current.strftime('%Y%m%d%H%M%S'),
      'vnp_CurrCode' => ENV['VNP_CURRCODE'],
      'vnp_IpAddr' => vnp_ipadd,
      'vnp_Locale' => ENV['VNP_LOCALE'],
      'vnp_OrderInfo' => vnp_order_info,
      'vnp_OrderType' => ENV['VNP_ORDER_TYPE'],
      'vnp_ReturnUrl' => ENV['VNP_RETURN_URL'],
      'vnp_TmnCode' => ENV['VNP_TMNCODE'],
      'vnp_TxnRef' => vnp_txnref,
      'vnp_Version' => ENV['VNP_VERSION'],
    }
    original_data = input_data.map do |key, value|
      "#{key}=#{value}"
    end.join('&')
    vnp_url = vnp_url + '?' + input_data.to_query
    vnp_security_hash = Digest::SHA256.hexdigest(vnp_hash_secret + original_data)
    vnp_url += '&vnp_SecureHashType=SHA256&vnp_SecureHash=' + vnp_security_hash
    vnp_url
  end
  def result
    # if checksum_valid!
    #   if params["vnp_ResponseCode"] == "00"
    #     current_user.cart.clear
    #     flash[:success] = t('.payment_success')
    #     redirect_to books_path
    #   else
    #     flash[:error] = t('.payment_failed')
    #     redirect_to checkouts_path
    #   end
    # else
    #   flash[:error] = t('.payment_failed')
    #   redirect_to checkouts_path
    # end
    if checksum_valid!
      permit_params = response_params
      unless session[:order].nil?
        vnp_amount = (session[:total_cart] * (1 - session[:coupon]['coupon_discount'] / 100) * 100).to_i
        if vnp_amount == (permit_params['vnp_Amount'].to_i / 100)
            if permit_params['vnp_ResponseCode'] == '00'
              session[:order].save
              code = '00'
              message = 'Confirm Success'
            else
              code = '11'
              message = 'Confirm Failed'
            end
            # save vnp_TransactionNo
            #order_object.transaction_id = permit_params['vnp_TransactionNo']
            #order_object.save!
        else
          code = '04'
          message = 'Invalid amount'
        end
      else
        code = '01'
        message = 'Order not found'
      end
    else
      code = '97'
      message = 'Invalid Checksum'
    end
    render json: {code: code, message: message}
  end
  def vnp_ipn
    logger = Logger.new("#{Rails.root}/log/payment_#{Date.today.to_s}.log")
    response_data = []
    if checksum_valid!
      permit_params = response_params
      unless session[:order].nil?
        vnp_amount = (session[:total_cart] * (1 - session[:coupon]['coupon_discount'] / 100) * 100).to_i
        if vnp_amount == (permit_params['vnp_Amount'].to_i / 100)
            if permit_params['vnp_ResponseCode'] == '00'
              Order.create!(session[:order])
              code = '00'
              message = 'Confirm Success'
            else
              code = '11'
              message = 'Confirm Failed'
            end
            # save vnp_TransactionNo
            #order_object.transaction_id = permit_params['vnp_TransactionNo']
            #order_object.save!
        else
          code = '04'
          message = 'Invalid amount'
        end
      else
        code = '01'
        message = 'Order not found'
      end
    else
      code = '97'
      message = 'Invalid Checksum'
    end
  
    logger.info("VNPAY with params: " + permit_params.to_s + ", code: #{code}, message: #{message}")
  
    render json: { 'RspCode': code, 'Message': message }
  rescue => e
    logger.error('VNPAY with params: ' + permit_params.to_s + '\', ' + e.message)
    render json: { 'RspCode': '99', 'Message': 'Unknow error' }
  end
  private
  def checksum_valid!
    vnp_secure_hash = params["vnp_SecureHash"]
    data = response_params.to_h.map do |key, value|
      "#{key}=#{value}"
    end.join("&")

    secure_hash = Digest::SHA256.hexdigest(ENV["VNP_HASH_SECRET"] + data)
    vnp_secure_hash == secure_hash
  end
  
  def response_params
    params.permit("vnp_Amount", "vnp_BankCode", "vnp_BankTranNo", "vnp_CardType", "vnp_OrderInfo", "vnp_PayDate", "vnp_ResponseCode", "vnp_TmnCode", "vnp_TransactionNo", "vnp_TxnRef")
  end
end
