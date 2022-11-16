function update_quantity(inventory_id){
    quantity = $('#cart-quantity-'+inventory_id).val();
    $.ajax({
        url: '/cart/update-quantity',
        type: 'post',
        data: {
            product: {
                inventory_id: inventory_id,
                quantity: quantity
            }
        },
        success: function(data){
            if(data.is_signed_in){
                if(data.is_error){
                    $('#cart-quantity-'+inventory_id).val(data.prev_quantity);
                    alert('Product or quantity invalid');
                }
                else{
                    $('#item-total-'+inventory_id).html(formatter.format(data.total));
                    $('#checkout-cart-total').html(formatter.format(data.cart_total));
                    $('#cart-item-quantity-'+inventory_id).html('Quantity:'+data.quantity);
                    $('#total-cart').html(formatter.format(data.cart_total));
                }
            }
            else{
                $('#sign-in').modal('show');
            }
        }        
    });
}
function proceed_to_checkout(){
    $.ajax({
        url: '/checkout/proceed-to-checkout',
        type: 'get',
        data: {
        },
        success: function(data){
            if(data.is_signed_in){
                if(data.is_cart_empty){
                    alert('Please go to the shop and add the product you want to buy to your cart');
                }
                else{
                    $('#checkout-information').html(data.html);
                }
            }
            else{
                $('#sign-in').modal('show');
            }
        }        
    });
}
function back_to_cart(){
    $.ajax({
        url: '/checkout/back-to-cart',
        type: 'get',
        data: {
        },
        success: function(data){
            if(data.is_signed_in){
                $('#checkout-information').html(data.html);
            }
            else{
                $('#sign-in').modal('show');
            }
        }        
    });
}
function apply_coupon(){
    coupon_id = $('#coupon').val();
    if(coupon_id.trim() == ''){
        alert('Please enter a valid coupon');
    }
    else{
        $.ajax({
            url: '/checkout/apply-coupon',
            type: 'post',
            data: {
                coupon: {
                    id: coupon_id
                }
            },
            success: function(data){
                if(data.is_signed_in){
                    $('#order-discount').html(formatter.format(data.discount));
                    $('#order-total-payment').html(formatter.format(data.total_payment));
                    if(data.is_available){
                        $('#coupon-notification').html('<label class="text-success p-2">Success!</label>');
                        $("coupon").prop('disabled', true);
                        $("apply-coupon").remove();
                    }
                    else{
                        $('#coupon-notification').html('<label class="text-danger p-2">Failure!</label>');
                        alert('Coupon does not exist');
                    }
                }
                else{
                    $('#sign-in').modal('show');
                }
            }        
        });
    }
}
function pay(){
    apartment_number = $('#apartment-number').val();
    street = $('#street').val();
    ward = $('#ward').val();
    district = $('#district').val();
    province = $('#province').val();
    coupon = $('#coupon').val();
    payment = $('#payments').find(":selected").val();
    $.ajax({
        url: '/checkout/pay',
        type: 'post',
        data: {
            order_info: {
                apartment_number: apartment_number,
                street: street,
                ward: ward,
                district: district,
                province: province,
                coupon: coupon,
                payment: payment
            }
        },
        success: function(data){
            if(data.is_signed_in){
                if(data.is_error){
                    alert('Please fill in your order information');
                }
                else{
                    window.location.href = data.payment_url;
                }
            }
            else{
                $('#sign-in').modal('show');
            }
        }        
    });
}