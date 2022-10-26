current_type_filter = 'all'
current_id = 'all'
function filter_products(type_filter, id){
    $.ajax({
        url: '/products/filter',
        type: 'get',
        data: {
            type_filter: type_filter,
            id: id
        },
        dataType: 'json',
        success: function(data){
            $('#products').html(data.html);
            items = document.getElementsByName('item')
            items.forEach(item => {
                item.classList.remove('text-success');
            });
            $('#'+type_filter).addClass('text-success');   
            $('#'+type_filter+'-'+id).addClass('text-success');
            current_type_filter = type_filter;
            current_id = id;
        }        
    });
}
function show_more(){
    $.ajax({
        url: '/products/show_more',
        type: 'get',
        data: {
            current_type_filter: current_type_filter,
            current_id: current_id
        },
        dataType: 'json',
        success: function(data){
            $('#products').append(data.html);
        }        
    });
}