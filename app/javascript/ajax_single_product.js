function ajax_get_quantity_in_stock(product_id){
    product_id = product_id.trim();
    color = $('#color').val().trim();
    size = $('#size').val().trim();
    $.ajax({
        url: '/products/get-quantity-in-stock',
        type: 'get',
        data: {
            product_id: product_id,
            color: color,
            size: size
        },
        dataType: 'json',
        success: function(inventory) {
            $('#var-value').html(1);
            $('#product-quantity').val(1);
            if(inventory.quantity_of_inventory == 0){
                $('#quantity').attr('hidden', true);
                $('#add-to-cart').attr('disabled', true);
                $('#product-quantity').attr('max', 0);
                $('#quantity-in-stock').html(0);
            }
            else{
                $('#quantity').attr('hidden', false);
                $('#add-to-cart').attr('disabled', false);
                $('#product-quantity').attr('max', inventory.quantity_of_inventory);
                $('#quantity-in-stock').html(inventory.quantity_of_inventory);
            }
        }
    });
}
function show_more(product_id){
    $.ajax({
        url: '/comments/show-more',
        type: 'get',
        data: {
            product_id: product_id
        },
        dataType: 'json',
        success: function(data){
            if(data.is_signed_in){
                $('#comments').append(data.html);
                if(data.is_show_more){
                    $('#show-more').show();
                }
                else{
                    $('#show-more').hide();
                }
            }
            else{
                $('#sign-in').modal('show');
            }
        }
    });
}
function post_comment(product_id){
    content = $('#input-comment').val();
    $.ajax({
        url: '/comments/post',
        type: 'post',
        data: {
            comment: {
                product_id: product_id,
                content: content
            }
        },
        success: function(data){
            if(data.is_signed_in){
                $('#comments').prepend(data.html);
                $('#input-comment').val('');
            }
            else{
                $('#sign-in').modal('show');
            }
        }        
    });
}
function add_to_cart(product_id){
    size = $('#size').val();
    color = $('#color').val();
    quantity = $('#product-quantity').val();
    $.ajax({
        url: '/cart/add-to-cart',
        type: 'post',
        data: {
            product: {
                product_id: product_id,
                size: size,
                color: color,
                quantity: quantity
            }
        },
        success: function(data){
            if(data.is_signed_in){
                if(data.is_error){
                    alert('Quantity invalid');
                }
                else{
                    if(data.is_available){
                        if(data.is_exist){
                            $('#cart-item-quantity-'+data.inventory_id).html('Quantity: '+data.quantity);
                        }
                        else{
                            $('#cart').append(data.html);
                        }
                        $('#count-cart').html(data.count_cart);    
                        $('#total-cart').html(formatter.format(data.total).replaceAll('.', ',')); 
                        $('#check-out-content').html('<hr class="text-success my-0 mb-2"/><div class="text-center"><a type="button" href="/checkout" class="btn btn-success text-white">Checkout</a></div>')
                    }
                    else{
                        alert('Product is not available');
                    }
                }
            }
            else{
                $('#sign-in').modal('show');
            }
        }        
    });
}
