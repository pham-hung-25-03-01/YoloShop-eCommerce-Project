$(document).on('ready turbolinks:load', function() {
    $('#page-loading').fadeOut('slow');
});
function active_color_image_item(element_current, product_id){
    color_image_items = document.getElementsByName('color-image-item');
    color_image_items.forEach(item => {
        item.classList.remove('active-item-img');
    });
    element_current.classList.add('active-item-img');
    $('#color').val(element_current.getElementsByTagName('img')[0].src);
    get_quantity_in_stock(product_id);
}
// $('.btn-size').click(function(){
//     var this_val = $(this).html();
//     $("#size").val(this_val);
//     $(".btn-size").removeClass('btn-secondary');
//     $(".btn-size").addClass('btn-success');
//     $(this).removeClass('btn-success');
//     $(this).addClass('btn-secondary');
//     display_quantity_input();
//     return false;
// });
function active_size_item(element_current, product_id){
    size_items = document.getElementsByName('size-item');
    size_items.forEach(item => {
        item.classList.remove('btn-secondary');
        item.classList.add('btn-success');
    });
    element_current.classList.remove('btn-success');
    element_current.classList.add('btn-secondary');
    $('#size').val(element_current.getElementsByTagName('span')[0].innerHTML);
    get_quantity_in_stock(product_id);
}
function get_quantity_in_stock(product_id){
    color = $('#color').val();
    size = $('#size').val();
    if(color.trim() != '' && size.trim() != ''){
        ajax_get_quantity_in_stock(product_id);
    }
}
function open_sign_in(){
    $('#sign-in').modal('show');
}
function open_shopping_cart(){
    $(".shopping-cart").fadeToggle( "fast");
}
function remove_from_cart(product_id, size, color){
    $.ajax({
        url: '/cart/remove-from-cart',
        type: 'post',
        data: {
            product: {
                product_id: product_id,
                size: size,
                color: color
            }
        },
        success: function(data){
            if(data.is_signed_in){
                if(data.is_error){
                    alert('Product invalid');
                }
                else{
                    $('#count-cart').html(data.count_cart);    
                    $('#cart-item-'+data.inventory_id).remove();
                    $('#total-cart').html('$'+data.total);
                    $('#checkout-item-'+data.inventory_id).remove();
                    if(data.is_cart_empty){
                        $('#check-out-content').html('<label class="text-center w-100">Cart is empty</label>');
                        $('#checkout-table').html('<label class="text-center w-100">Your cart is empty.</label>');
                    }
                    else{
                        $('#check-out-content').html('<hr class="text-success my-0 mb-2"/><div class="text-center"><a type="button" href="/checkout/index" class="btn btn-success text-white">Checkout</a></div>')
                    }
                }
            }
            else{
                $('#sign-in').modal('show');
            }
        }        
    });
}
function products_favorite(product_id){
    $.ajax({
        url: '/reviews/favorite',
        type: 'post',
        data: {
            review: {
                product_id: product_id
            }
        },
        success: function(data){
            if(data.is_signed_in){
                $('#count-favorite').html(data.count_favorite);
                if(data.review.is_favored){
                    $('#btn-favorite-' + product_id).removeClass('btn-success');
                    $('#btn-favorite-' + product_id).addClass('btn-secondary');
                    $('#btn-favorite').html('Unfavorite');
                    $('#btn-favorite').removeClass('btn-success');
                    $('#btn-favorite').addClass('btn-secondary');
                    if(data.count_favorite == 1){
                        $('#favorite').html(data.html);
                    }
                    else{
                        $('#favorite').append(data.html);
                    }
                }
                else{
                    $('#btn-favorite-' + product_id).removeClass('btn-secondary');
                    $('#btn-favorite-' + product_id).addClass('btn-success');
                    $('#btn-favorite').html('Favorite');
                    $('#btn-favorite').removeClass('btn-secondary');
                    $('#btn-favorite').addClass('btn-success');
                    $('#favorite-item-'+ data.review.product_id).remove();
                }
                if(data.count_favorite == 0){
                    $('#favorite').html('<label class="text-center w-100">You haven\'t favored any products yet</label>');
                }
            }
            else{
                $('#sign-in').modal('show');
            }
        }        
    });
}
function open_dropdown(e) {
    e.stopPropagation();
    e.preventDefault();
}
function open_dropdown_without_preventDefault(e) {
    e.stopPropagation();
}
$('.dropdown-item').on('click', function(e){
    e.stopPropagation();
})