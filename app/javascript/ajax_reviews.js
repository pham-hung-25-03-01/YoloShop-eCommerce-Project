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
                if(data.review.is_favored){
                    $('#btn-favorite-' + product_id).removeClass('btn-success');
                    $('#btn-favorite-' + product_id).addClass('btn-secondary');
                }
                else{
                    $('#btn-favorite-' + product_id).removeClass('btn-secondary');
                    $('#btn-favorite-' + product_id).addClass('btn-success');
                }
            }
            else{
                $('#sign-in').modal('show');
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
                if(data.review.is_favored){
                    $('#btn-favorite').html('Unfavorite');
                    $('#btn-favorite').removeClass('btn-success');
                    $('#btn-favorite').addClass('btn-secondary');
                }
                else{
                    $('#btn-favorite').html('Favorite');
                    $('#btn-favorite').removeClass('btn-secondary');
                    $('#btn-favorite').addClass('btn-success');
                }
            }
            else{
                $('#sign-in').modal('show');
            }
        }        
    });
}
function rating(product_id, score_rating){
    $.ajax({
        url: '/reviews/rating',
        type: 'post',
        data: {
            product_id: product_id,
            score_rating: score_rating       
        },
        success: function(data){
            if(data.is_signed_in){
                product_score_rating = (Math.round(data.score_rating * 100) / 100).toFixed(1);
                for(let i=0; i<5; i++){
                    $('#product-star-rate-'+ i).removeClass('text-muted text-warning');
                    if( i+1 == Math.round(product_score_rating) && product_score_rating - parseInt(product_score_rating) >= 0.5){
                        $('#product-star-rate-'+ i).removeClass('fa-star');
                        $('#product-star-rate-'+ i).addClass('fa-star-half text-warning');
                    }
                    else{
                        $('#product-star-rate-'+ i).removeClass('fa-star-half');
                        $('#product-star-rate-'+ i).addClass('fa-star');
                        if(i+1 <=product_score_rating){
                            $('#product-star-rate-'+ i).addClass('text-warning');
                        }
                        else{
                            $('#product-star-rate-'+ i).addClass('text-muted');
                        }
                    }
                }                
                $('#rate').html('Rating '+ product_score_rating +' ('+ data.number_of_rates +' rates) | 0 Comments');
                for(let i=0; i<5; i++){
                    $('#star-rate-'+ i).removeClass('text-muted text-warning');
                    $('#star-rate-'+ data.user_id +'-'+ i).removeClass('text-muted text-warning');
                    if(i+1 <= score_rating){
                        $('#star-rate-'+ i).addClass('text-warning');
                        $('#star-rate-'+ data.user_id +'-'+ i).addClass('text-warning');
                    }
                    else{
                        $('#star-rate-'+ i).addClass('text-muted');
                        $('#star-rate-'+ data.user_id +'-'+ i).addClass('text-muted');
                    }
                }
            }
            else{
                $('#sign-in').modal('show');
            }
        }        
    });
}