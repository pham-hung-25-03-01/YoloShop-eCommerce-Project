function get_order_details(order_id){
    $.ajax({
        url: '/orders/get-order-details',
        type: 'get',
        data: {
            order_id: order_id
        },
        dataType: 'json',
        success: function(data){
            if(data.is_signed_in){
                $('#order-details-content').html(data.html);
                $('#order-details').modal('show');
            }
            else{
                $('#sign-in').modal('show');
            }
        }        
    });
}