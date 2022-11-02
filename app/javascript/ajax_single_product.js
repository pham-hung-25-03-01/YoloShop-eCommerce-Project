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
            if(inventory == null){
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
            $('#comments').append(data.html);
            if(data.is_show_more){
                $('#show-more').show();
            }
            else{
                $('#show-more').hide();
            }
        }
    });
}