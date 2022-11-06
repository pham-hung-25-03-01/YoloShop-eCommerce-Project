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
                    $('#cart-quantity-'+inventory_id).val(data.prev_quantity)
                    alert('Product or quantity invalid');
                }
                else{
                    $('#item-total-'+inventory_id).html('$'+data.total);
                    $('#checkout-cart-total').html('$'+data.cart_total);
                    $('#cart-item-quantity-'+inventory_id).html('Quantity:'+data.quantity);
                    $('#total-cart').html('$'+data.cart_total);
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