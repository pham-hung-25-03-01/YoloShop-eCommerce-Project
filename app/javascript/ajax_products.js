type_filter_current = 'all'
id_current = 'all'
option_current = 'name'
function filter_products(type_filter, id){
    if(id != id_current){
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
            option: option_current,
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
            type_filter_current = type_filter;
            id_current = id;
        }        
    });
}
function show_more(){
    search_keyword_current = $('#search-keyword').val().trim();
    $.ajax({
        url: '/products/show-more',
        type: 'get',
        data: {
            type_filter_current: type_filter_current,
            id_current: id_current,
            option_current: option_current,
            search_keyword_current: search_keyword_current
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
    option_current = option_filter.options[option_filter.selectedIndex].value;
    search_keyword_current = $('#search-keyword').val().trim();
    ajax_filter_products(type_filter_current, id_current, search_keyword_current);
}
function search_keyword_filter(){
    search_keyword_current = $('#search-keyword').val().trim();
    ajax_filter_products(type_filter_current, id_current, search_keyword_current);
}