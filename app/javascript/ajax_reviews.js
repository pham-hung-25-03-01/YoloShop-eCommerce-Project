function rating(product_id, user_score_rating){
    $.ajax({
        url: '/reviews/rating',
        type: 'post',
        data: {
            review: {
                product_id: product_id,
                user_score_rating: user_score_rating
            }     
        },
        success: function(data){
            if(data.is_signed_in){
                product_score_rating = (Math.round(data.score_rating * 100) / 100).toFixed(1);
                if($('#product-star-rate-5').length == 0){
                    $('#product-star-rate').append('<i id="product-star-rate-5" class="text-muted fa fa-star"></i>')
                }
                $('#product-star-rate-5').show();
                for(let i=0; i<5; i++){
                    $('#product-star-rate-'+ i).removeClass('text-muted text-warning star-half-decoration');
                    if( i+1 == Math.round(product_score_rating) && product_score_rating - parseInt(product_score_rating) >= 0.5){
                        $('#product-star-rate-'+ i).removeClass('fa-star');
                        $('#product-star-rate-'+ i).addClass('fa-star-half text-warning star-half-decoration');
                    }
                    else{
                        $('#product-star-rate-'+ i).removeClass('fa-star-half star-half-decoration');
                        $('#product-star-rate-'+ i).addClass('fa-star');
                        if(i+1 <= product_score_rating){
                            $('#product-star-rate-'+ i).addClass('text-warning');
                        }
                        else{
                            $('#product-star-rate-'+ i).addClass('text-muted');
                        }
                    }
                }  
                if(product_score_rating - parseInt(product_score_rating) < 0.5){
                    $('#product-star-rate-5').hide();
                }         
                $('#rate').html('Rating '+ product_score_rating +' ('+ data.number_of_rates +' rates) | 0 Comments');
                for(let i=0; i<5; i++){
                    $('#star-rate-'+ i).removeClass('text-muted text-warning');
                    $("i[name='star-rate-"+ data.user_id +"-"+ i+"']").removeClass('text-muted text-warning');
                    if(i+1 <= user_score_rating){
                        $('#star-rate-'+ i).addClass('text-warning');
                        $("i[name='star-rate-"+ data.user_id +"-"+ i+"']").addClass('text-warning');
                    }
                    else{
                        $('#star-rate-'+ i).addClass('text-muted');
                        $("i[name='star-rate-"+ data.user_id +"-"+ i+"']").addClass('text-muted');
                    }
                }
                //document.getElementById('').onmouseout = out_animation_rating(user_score_rating - 1);
                //$('#star-rate').prop('onmouseout', out_animation_rating(user_score_rating - 1));
            }
            else{
                $('#sign-in').modal('show');
            }
        }        
    });
}

function animation_rating(element){
    index = parseInt(element.id[element.id.length - 1]);
    for(let i=0; i<=index; i++){
        $('#star-rate-'+ i).removeClass('text-muted');
        $('#star-rate-'+ i).addClass('text-warning');
    }
    for(let j=index+1; j<5; j++){
        $('#star-rate-'+ j).removeClass('text-warning');
        $('#star-rate-'+ j).addClass('text-muted');
    }
}
function out_animation_rating(index){
    for(let i=0; i<=index; i++){
        $('#star-rate-'+ i).removeClass('text-muted');
        $('#star-rate-'+ i).addClass('text-warning');
    }
    for(let j=index+1; j<5; j++){
        $('#star-rate-'+ j).removeClass('text-warning');
        $('#star-rate-'+ j).addClass('text-muted');
    }
}