class UsersController < ApplicationController
  def edit
    begin
      if user_signed_in?
        @user = User.find_by(
          id: params[:id]
        ) or redirect_to_404
      else
        redirect_to root_path
      end
    rescue StandardError => e
      p e.message
      p e.backtrace
    end
  end
  def update_user_information
    begin
      if user_signed_in?
        first_name = params[:user][:first_name].strip
        last_name = params[:user][:last_name].strip
        gender = params[:user][:gender].strip
        birthday = params[:user][:birthday].strip
        phone_number = params[:user][:phone_number].strip
        apartment_number = params[:user][:apartment_number].strip
        street = params[:user][:street].strip
        ward = params[:user][:ward].strip
        district = params[:user][:district].strip
        province = params[:user][:province].strip
        return render json: {
          is_signed_in: true,
          is_update_success: false
        } if last_name.empty? || phone_number.empty?
        current_user.first_name = first_name
        current_user.last_name = last_name
        current_user.gender = gender.eql?('-1') ? nil : gender.to_i
        current_user.birthday = birthday.empty? ? nil : Date.parse(birthday)
        current_user.phone_number = phone_number
        current_user.apartment_number = apartment_number.empty? ? nil : apartment_number
        current_user.street = street.empty? ? nil : street
        current_user.ward = ward.empty? ? nil : ward
        current_user.district = district.empty? ? nil : district
        current_user.province = province.empty? ? nil : province
        current_user.updated_by = current_user.id
        current_user.save
        return render json: {
          is_signed_in: true,
          is_update_success: false
        } unless current_user.valid?
        return render json: {
          is_signed_in: true,
          is_update_success: true
        }
      else
        render json: {
          is_signed_in: false
        }
      end
    rescue StandardError => e
      p e.message
      p e.backtrace
    end
  end
  def update_user_password
    begin
      if user_signed_in?
        password = params[:user][:password]
        return render json: {
          is_signed_in: true,
          is_update_success: false,
          message: 'Password must contains at least six characters, including at least one lowercase letter, one uppercase letter, one digit and one special character!'
        } unless password_complexity?(password)
        current_user.encrypted_password = BCrypt::Password.create(password)
        current_user.updated_by = current_user.id
        current_user.save
        return render json: {
          is_signed_in: true,
          is_update_success: true
        }
      else
        render json: {
          is_signed_in: false
        }
      end
    rescue StandardError => e
      p e.message
      p e.backtrace
    end
  end
  def update_avatar
    begin
      if user_signed_in?
        return render json: {
          is_signed_in: true,
          is_update_success: false,
          message: 'File is invalid'
        } if params[:file].eql?('undefined')
        unless current_user.avatar_url.nil?
          public_id = current_user.avatar_url.split('/')[-1].split('.')[0]
          Cloudinary::Uploader.destroy(public_id)
        end
        File.open(
          Rails.root.join(
            'public',
            'uploads',
            params[:file].original_filename
          ),
          'wb'
        ) do |file|
          file.write(
            params[:file].read
          )
        end
        image_url = "public/uploads/#{params[:file].original_filename}"
        avatar_url = Cloudinary::Uploader.upload(image_url)['url']
        current_user.avatar_url = avatar_url
        current_user.save
        File.delete(image_url) if File.exist?(image_url)
        return render json: {
          is_signed_in: true,
          is_update_success: true,
          avatar_url: avatar_url
        }
      else
        render json: {
          is_signed_in: false
        }
      end
    rescue StandardError => e
      p e.message
      p e.backtrace
    end
  end
  def orders_history
    begin
      if user_signed_in?
        @orders = Order.where(
          user_id: current_user.id,
          is_actived: true
        ).order(created_at: :DESC)
      else
        redirect_to root_path
      end
    rescue StandardError => e
      p e.message
      p e.backtrace
    end
  end
  private
  def password_complexity?(password)
    if password.empty? and not password.match(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{6,}$/)
      false
    else
      true
    end
  end
end
