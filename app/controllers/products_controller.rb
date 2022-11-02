class ProductsController < ApplicationController
  DEFAULT_PER_PAGE = ENV['DEFAULT_PER_PAGE'].to_i
  DEFAULT_PER_COMMENT = ENV['DEFAULT_PER_COMMENT'].to_i
  def filter
    begin
      type_filter = params[:type_filter]
      id = params[:id]
      option = params[:option]
      search_keyword = params[:search_keyword]
      is_show_more = true
      all_products, count_products = do_filter type_filter, id, option, search_keyword
      session[:product_offset] = DEFAULT_PER_PAGE unless type_filter.eql?(session[:prev_type_filter])
      @products = all_products.limit(session[:product_offset])
      session[:prev_type_filter] = type_filter
      is_show_more = false if session[:product_offset] >= count_products
      render json: { html: render_to_string(partial: 'layouts/partials/product', collection: @products, as: :product), is_show_more: is_show_more }
    rescue StandardError => e
      p e.message
      p e.backtrace
    end
  end

  def show_more
    begin
      @@product_offset = session[:product_offset]
      type_filter_current = params[:type_filter_current]
      id_current = params[:id_current]
      option_current = params[:option_current]
      search_keyword_current = params[:search_keyword_current]
      is_show_more = true
      all_products, count_products = do_filter type_filter_current, id_current, option_current, search_keyword_current
      @products = all_products.offset(session[:product_offset]).limit(DEFAULT_PER_PAGE)
      session[:product_offset] += DEFAULT_PER_PAGE
      is_show_more = false if session[:product_offset] >= count_products
      render json: { html: render_to_string(partial: 'layouts/partials/product', collection: @products, as: :product), is_show_more: is_show_more}
    rescue StandardError => e
      p e.message
      p e.backtrace
    end
  end

  def show
    begin
      @product = Product.find_by(meta_title: params[:meta_title])
      @supplier = Supplier.find(@product.supplier_id)
      @category = Category.find(@product.category_id)
      @age = Age.find(@product.age_id)
      all_comments = Comment.where(product_id: @product.id, is_actived: true).order(created_at: :DESC)
      @comments = all_comments.limit(DEFAULT_PER_COMMENT)
      session[:comment_offset] = DEFAULT_PER_COMMENT
      @reviews = Review.where(product_id: @product.id)
      @is_show_more = DEFAULT_PER_COMMENT < all_comments.count ? true : false
    rescue StandardError => e
      p e.message
      p e.backtrace
    end
  end

  def get_quantity_in_stock
    begin
      @inventory = Inventory.find_by(product_id: params[:product_id], color_url: params[:color], size: params[:size])
      render json: @inventory
    rescue StandardError => e
      p e.message
      p e.backtrace
    end
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
