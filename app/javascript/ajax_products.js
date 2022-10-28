current_type_filter = 'all'
current_id = 'all'
current_option = 'name'
function filter_products(type_filter, id){
    if(id != current_id){
        search_keyword = $('#search-keyword').val().trim();
        ajax_filter_products(type_filter, id, search_keyword);
    }
}
function ajax_filter_products(type_filter, id, search_keyword){
    $.ajax({
        url: '/products/filter',
        type: 'get',
        data: {
            type_filter: type_filter,
            id: id,
            option: current_option,
            search_keyword: search_keyword
        },
        dataType: 'json',
        success: function(data){
            $('#products').html(data.html);
            options = document.getElementsByName('options')
            options.forEach(option => {
                option.style.display = 'none';
            });
            type_filter_options = document.getElementById(type_filter + '-options')
            if(type_filter_options != null){
                type_filter_options.style.display = 'block'
                $('#'+type_filter).trigger('click');
            }
            items = document.getElementsByName('item')
            items.forEach(item => {
                item.classList.remove('text-success');
            });
            $('#'+type_filter).addClass('text-success');
            $('#'+type_filter+'-'+id).addClass('text-success');
            $('#'+type_filter+'-control-'+id).addClass('text-success');
            if(data.is_show_more){
                $('#show-more').removeClass('invisible').addClass('visible');
            }
            else{
                $('#show-more').removeClass('visible').addClass('invisible');
            }
            if(document.getElementsByName('product').length > 0){
                $('#no-products').removeClass('visible').addClass('invisible');
            }
            else{
                $('#no-products').removeClass('invisible').addClass('visible');
            }
            current_type_filter = type_filter;
            current_id = id;
        }        
    });
}
function show_more(){
    current_search_keyword = $('#search-keyword').val().trim();
    $.ajax({
        url: '/products/show-more',
        type: 'get',
        data: {
            current_type_filter: current_type_filter,
            current_id: current_id,
            current_option: current_option,
            current_search_keyword: current_search_keyword
        },
        dataType: 'json',
        success: function(data){
            $('#products').append(data.html);
            if(data.is_show_more){
                $('#show-more').removeClass('invisible').addClass('visible');
            }
            else{
                $('#show-more').removeClass('visible').addClass('invisible');
            }
            if(document.getElementsByName('product').length > 0){
                $('#no-products').removeClass('visible').addClass('invisible');
            }
            else{
                $('#no-products').removeClass('invisible').addClass('visible');
            }
        }        
    });
}
function change_option_filter(){
    option_filter = document.getElementById('option-filter');
    current_option = option_filter.options[option_filter.selectedIndex].value;
    current_search_keyword = $('#search-keyword').val().trim();
    ajax_filter_products(current_type_filter, current_id, current_search_keyword);
}
function search_keyword_filter(){
    current_search_keyword = $('#search-keyword').val().trim();
    ajax_filter_products(current_type_filter, current_id, current_search_keyword);
}