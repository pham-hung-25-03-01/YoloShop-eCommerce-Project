module NeighborhoodBasedCollaborativeFiltering
    attr_accessor :user_ids, :product_ids, :original_utility_matrix, :normalized_utility_matrix, :item_similarity_matrix

    def nbcf_initialize()
        @user_ids = User.all.pluck(:id)
        @product_ids = Product.where(is_actived: true).pluck(:id)
        @original_utility_matrix = Array.new(@product_ids.count) { Array.new(@user_ids.count + 1, 0) }
        @normalized_utility_matrix = Array.new(@product_ids.count) { Array.new(@user_ids.count, 0) }
        @item_similarity_matrix = Array.new(@product_ids.count) { Array.new(@product_ids.count) }
    end
    def get_original_utility_matrix
        row = 0
        @product_ids.each do |product_id|
            reviews = Review.where(product_id: product_id)
            count = 0
            reviews.each do |review|
                unless review.user_score_rating.nil?
                    index = @user_ids.find_index review.user_id
                    @original_utility_matrix[row][index] = review.user_score_rating
                    count += 1
                end
            end
            avg_score_rating = count == 0 ? 0 : reviews.sum(:user_score_rating) * 1.0 / count
            @original_utility_matrix[row][-1] = avg_score_rating
            row += 1
        end
    end
    def normalized_original_utility_matrix
        @original_utility_matrix.each_with_index do |original_utility_row, row|
            original_utility_row.each_with_index do |original_utility_element, col|
                if original_utility_element != 0 && col < original_utility_row.length() - 1
                    @normalized_utility_matrix[row][col] = original_utility_element - original_utility_row[-1]
                end
            end
        end
    end
    def cosine_similarity(first_products, second_products)
        length_first_products = length_vector first_products
        length_second_products = length_vector second_products
        scalar = cal_scalar first_products, second_products
        if length_first_products * length_second_products == 0
            1
        else
            scalar / (length_first_products * length_second_products)
        end
    end
    def length_vector(products)
        result = 0
        products.each do |item|
            result += item ** 2
        end
        Math.sqrt(result)
    end
    def cal_scalar(first_products, second_products)
        result = 0
        length = first_products.length
        length.times do |index|
            result += first_products[index] * second_products[index]
        end
        result
    end
    def cal_item_similarity_matrix
        amount_item = @product_ids.count
        amount_item.times do |i|
            row = @normalized_utility_matrix[i]
            i.times do |j|
                @item_similarity_matrix[i][j] = cosine_similarity row, @normalized_utility_matrix[j]
                @item_similarity_matrix[j][i] = @item_similarity_matrix[i][j]
            end
            @item_similarity_matrix[i][i] = 1
        end
    end
    def rating_prediction(products, col)
        numerator = 0
        denominator = 0
        length = products.length
        length.times do |index|
            unless products[index] == 0
                numerator += products[index] * @item_similarity_matrix[index][col]
                denominator += @item_similarity_matrix[index][col].abs
            end
        end
        numerator / denominator
    end
    def get_recommended_products(user_id)
        get_original_utility_matrix
        normalized_original_utility_matrix
        cal_item_similarity_matrix
        col = user_ids.find_index user_id
        products = temp_products = normalized_utility_matrix.transpose[col]
        recommended_products = []
        products.each_index do |index|
            products[index] = rating_prediction(temp_products, index) + @original_utility_matrix[index][-1]
            recommended_products << [product_ids[index], products[index]]
        end
        recommended_products.sort_by!(&:last)
        recommended_products.transpose.first
    end
    private :get_original_utility_matrix, :normalized_original_utility_matrix, :cosine_similarity, :length_vector, :cal_scalar, :cal_item_similarity_matrix, :rating_prediction
end