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
