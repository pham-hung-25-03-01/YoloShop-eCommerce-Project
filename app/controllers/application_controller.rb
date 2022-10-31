class ApplicationController < ActionController::Base
    before_action :count_favorite
    def count_favorite
        unless current_user.nil?
            session[:count_favorite] = Review.where(user_id: current_user.id, is_favored: true).count
        else
            session[:count_favorite] = nil
        end
    end
end
    