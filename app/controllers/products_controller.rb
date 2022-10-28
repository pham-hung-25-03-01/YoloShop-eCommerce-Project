class ProductsController < ApplicationController
  DEFAULT_PER_PAGE = ENV['DEFAULT_PER_PAGE'].to_i

  def filter
    begin
      type_filter = params[:type_filter]
      id = params[:id]
      option = params[:option]
      search_keyword = params[:search_keyword]
      is_show_more = true
      all_products, count_products = do_filter type_filter, id, option, search_keyword
      session[:off_set] = DEFAULT_PER_PAGE unless type_filter.eql?(session[:prev_type_filter])
      @products = all_products.limit(session[:off_set])
      session[:prev_type_filter] = type_filter
      is_show_more = false if session[:off_set] >= count_products
    rescue StandardError => e
      p e.message
      p e.backtrace
    end
    render json: { html: render_to_string(partial: 'layouts/partials/product', collection: @products, as: :product), is_show_more: is_show_more }
  end

  def show_more
    begin
      @@off_set = session[:off_set]
      current_type_filter = params[:current_type_filter]
      current_id = params[:current_id]
      current_option = params[:current_option]
      current_search_keyword = params[:current_search_keyword]
      is_show_more = true
      all_products, count_products = do_filter current_type_filter, current_id, current_option, current_search_keyword
      @products = all_products.offset(session[:off_set]).limit(DEFAULT_PER_PAGE)
      session[:off_set] += DEFAULT_PER_PAGE
      is_show_more = false if session[:off_set] >= count_products
    rescue StandardError => e
      p e.message
      p e.backtrace
    end
    render json: { html: render_to_string(partial: 'layouts/partials/product', collection: @products, as: :product), is_show_more: is_show_more}
  end

  def info_product
    @product = Product.find(params[:id])
    @supplier = Supplier.find(@product.supplier_id)
    @category = Category.find(@product.category_id)
    @age = Age.find(@product.age_id)
  end

  private
  def do_filter(type_filter, id, option, search_keyword)
    search_keyword.strip!
    if type_filter.eql?('all') || id.eql?('all')
      all_products = Product.where(is_actived: true)
    else
      case type_filter
      when 'categories'
        all_products = Product.where({categories: Category.where(is_actived: true, id: id)})
      when 'ages'
        all_products = Product.where({ages: Age.where(is_actived: true, id: id)})
      when 'gender'
        all_products = Product.where(is_actived: true, gender: id.downcase.eql?('true'))
      when 'product_groups'
        all_products = Product.where({product_groups: ProductGroup.where(is_actived: true, id: id)})
      when 'events'
        all_products = Product.where({events: Event.where(is_actived: true, id: id)})
      when 'sale'
        all_products = Product.where(is_actived: true).where('product_discount > 0')
      end
    end
    case option
    when 'name'
      all_products = all_products.order(product_name: :ASC)
    when 'newest'
      all_products = all_products.order(created_at: :DESC)
    when 'price'
      all_products = all_products.order(Arel.sql('(products.sell_price * (1 - products.product_discount / 100)) ASC'))
    end
    all_products = all_products.where("LOWER(product_name) LIKE ?", "%#{search_keyword.downcase}%") unless search_keyword.empty?
    [all_products, all_products.count]
  end
end
