$(document).on('ready turbolinks:load', function() {
    $('#page-loading').fadeOut('slow');
});
function filter_products(type_filter, value){
    $.ajax({
        type: 'GET',
        url: '/products/filter_by_' + type_filter + "/category=" + value,
        dataType: 'json',
        success: function(products){
            content = document.getElementById('products')
            html = ''
            for(let i = 0; i < products.length; i++){
                html += '<div class="col-md-4">'+
                    '<div class="card mb-4 product-wap rounded-0">'+
                        '<div class="card rounded-0">'+
                            '<img src="'+ products[i].product_images.find(p => p.is_default == true).image_url +'" class="card-img rounded-0 img-fluid" alt="'+ products[i].product_name +'"></img>'+
                            '<div class="card-img-overlay rounded-0 product-overlay d-flex align-items-center justify-content-center">'+
                                '<ul class="list-unstyled">'+
                                    '<li><a class="btn btn-success text-white" href="shop-single.html"><i class="far fa-heart"></i></a></li>'+
                                    '<li><a class="btn btn-success text-white mt-2" href="shop-single.html"><i class="far fa-eye"></i></a></li>'+
                                    '<li><a class="btn btn-success text-white mt-2" href="shop-single.html"><i class="fas fa-cart-plus"></i></a></li>'+
                                '</ul>'+
                            '</div>'+
                        '</div>'+
                        '<div class="card-body">'+
                            '<a href="shop-single.html" class="h3 text-decoration-none">'+ products[i].product_name +'</a>'+
                            '<ul class="w-100 list-unstyled d-flex justify-content-between mb-0">'+
                                '<li>'+ products[i].origin +'</li>'+
                                '<li class="pt-2">'+
                                    '<span class="product-color-dot color-dot-red float-left rounded-circle ml-1"></span>'+
                                    '<span class="product-color-dot color-dot-blue float-left rounded-circle ml-1"></span>'+
                                    '<span class="product-color-dot color-dot-black float-left rounded-circle ml-1"></span>'+
                                    '<span class="product-color-dot color-dot-light float-left rounded-circle ml-1"></span>'+
                                    '<span class="product-color-dot color-dot-green float-left rounded-circle ml-1"></span>'+
                                '</li>'+
                            '</ul>'+
                            '<ul class="list-unstyled d-flex justify-content-center mb-1">'+
                                '<li>'
                for(let j = 0; j < parseInt(products[i].score_rating, 10); j++) {
                    html += '<i class="text-warning fa fa-star"></i>'
                }
                if(products[i].score_rating - parseInt(products[i].score_rating) > 0.5){
                    html += '<i class="text-warning fa fa-star-half"></i>'
                }
                for(let k = 0; k < 5 - parseInt(products[i].score_rating); k++){
                    html += ' <i class="text-muted fa fa-star"></i>'
                }
                html += '</li>'+
                        '</ul>'+
                        '<p class="text-center mb-0">$' + products[i].sell_price * (1 - products[i].product_discount / 100) +
                            products[i].product_discount == 0 ? '' : '&nbsp;&nbsp;&nbsp;<s>$'+ products[i].sell_price +'</s>' +
                        '</p>'+
                        '</div>'+
                        '</div>'+
                        '</div>'
            }
        }        
    });
}