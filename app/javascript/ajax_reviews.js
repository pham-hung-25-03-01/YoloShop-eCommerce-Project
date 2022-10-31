function products_favorite(product_id){
    $.ajax({
        url: '/reviews/favorite',
        type: 'post',
        data: {
            product_id: product_id        
        },
        success: function(data){
            if(data.is_signed_in){
                $('#favorite').html(data.count_favorite);
            }
            else{
                $('#sign-in').modal('show');
            }
            if(data.review.is_favored){
                $('#btn-favorite-' + product_id).removeClass('btn-success');
                $('#btn-favorite-' + product_id).addClass('btn-secondary');
            }
            else{
                $('#btn-favorite-' + product_id).removeClass('btn-secondary');
                $('#btn-favorite-' + product_id).addClass('btn-success');
            }
        }        
    });
}
function single_product_favorite(product_id){
    $.ajax({
        url: '/reviews/favorite',
        type: 'post',
        data: {
            product_id: product_id        
        },
        success: function(data){
            if(data.is_signed_in){
                $('#favorite').html(data.count_favorite);
            }
            else{
                $('#sign-in').modal('show');
            }
            if(data.review.is_favored){
                $('#btn-favorite').html('Unfavorite');
            }
            else{
                $('#btn-favorite').html('Favorite');
            }
        }        
    });
}