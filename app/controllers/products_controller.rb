class ProductsController < ApplicationController
  OFFSET_DEFAULT = 3
  @@offset = OFFSET_DEFAULT
  @@items_per_page = 3

  def filter
    begin
      type_filter = params[:type_filter]
      id = params[:id]
      if type_filter.eql?('all') || id.eql?('all')
        @products = Product.where(is_actived: true).limit(@@items_per_page)
      else
        case type_filter
        when 'categories'
          @products = Product.where({categories: Category.where(is_actived: true, id: id)}).limit(@@items_per_page)
        when 'ages'
          @products = Product.where({ages: Age.where(is_actived: true, id: id)}).limit(@@items_per_page)
        when 'gender'
          @products = Product.where(is_actived: true, gender: id.downcase.eql?('true')).limit(@@items_per_page)
        when 'sale'
          @products = Product.where(is_actived: true).where('product_discount > 0').limit(@@items_per_page)
        when 'product_groups'
          @products = Product.where({product_groups: ProductGroup.where(is_actived: true, id: id)}).limit(@@items_per_page)
        end
      end
      @@offset = OFFSET_DEFAULT
    rescue StandardError => e
      p e.message
      p e.backtrace
    end
    render json: { html: render_to_string(partial: 'layouts/partials/product', collection: @products, as: :product) }
  end

  def show_more
    begin
      current_type_filter = params[:current_type_filter]
      current_id = params[:current_id]
      if current_type_filter.eql?('all') || current_id.eql?('all')
        @products = Product.where(is_actived: true).offset(@@offset).limit(@@items_per_page)
      else
        case current_type_filter
        when 'categories'
          @products = Product.where({categories: Category.where(is_actived: true, id: current_id)}).offset(@@offset).limit(@@items_per_page)
        when 'ages'
          @products = Product.where({ages: Age.where(is_actived: true, id: current_id)}).offset(@@offset).limit(@@items_per_page)
        when 'gender'
          @products = Product.where(is_actived: true, gender: current_id.downcase.eql?('true')).offset(@@offset).limit(@@items_per_page)
        when 'sale'
          @products = Product.where(is_actived: true).where('product_discount > 0').offset(@@offset).limit(@@items_per_page)
        when 'product_groups'
          @products = Product.where({product_groups: ProductGroup.where(is_actived: true, id: current_id)}).offset(@@offset).limit(@@items_per_page)
        end
      end
      @@offset += @@items_per_page
    rescue StandardError => e
      p e.message
      p e.backtrace
    end
    render json: { html: render_to_string(partial: 'layouts/partials/product', collection: @products, as: :product) }
  end
end
