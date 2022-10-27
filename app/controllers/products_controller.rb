class ProductsController < ApplicationController
  DEFAULT_PER_PAGE = ENV['DEFAULT_PER_PAGE'].to_i
  #here
  prev_type_filter = 'all'
  
  def filter
    begin
      type_filter = params[:type_filter]
      id = params[:id]
      option = params[:option]
      is_show_more = true
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
        when 'sale'
          all_products = Product.where(is_actived: true).where('product_discount > 0')
        when 'product_groups'
          all_products = Product.where({product_groups: ProductGroup.where(is_actived: true, id: id)})
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
      @products = all_products.limit(DEFAULT_PER_PAGE)
      count_products = all_products.count

      #here
      session[:off_set] = DEFAULT_PER_PAGE unless type_filter.eql?(prev_type_filter)
      prev_type_filter = type_filter
      
      
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
      is_show_more = true
      if current_type_filter.eql?('all') || current_id.eql?('all')
        all_products = Product.where(is_actived: true)
      else
        case current_type_filter
        when 'categories'
          all_products = Product.where({categories: Category.where(is_actived: true, id: current_id)})
        when 'ages'
          all_products = Product.where({ages: Age.where(is_actived: true, id: current_id)})
        when 'gender'
          all_products = Product.where(is_actived: true, gender: current_id.downcase.eql?('true'))
        when 'sale'
          all_products = Product.where(is_actived: true).where('product_discount > 0')
        when 'product_groups'
          all_products = Product.where({product_groups: ProductGroup.where(is_actived: true, id: current_id)})
        end
      end
      case current_option
      when 'name'
        all_products = all_products.order(product_name: :ASC)
      when 'newest'
        all_products = all_products.order(created_at: :DESC)
      when 'price'
        all_products = all_products.order(Arel.sql('(products.sell_price * (1 - products.product_discount / 100)) ASC'))
      end
      @products = all_products.offset(session[:off_set]).limit(DEFAULT_PER_PAGE)
      count_products = all_products.count
      session[:off_set] += DEFAULT_PER_PAGE
      is_show_more = false if session[:off_set] >= count_products
    rescue StandardError => e
      p e.message
      p e.backtrace
    end
    render json: { html: render_to_string(partial: 'layouts/partials/product', collection: @products, as: :product), is_show_more: is_show_more}
  end
end
