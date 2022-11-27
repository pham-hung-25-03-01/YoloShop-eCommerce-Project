function update_user_information(){
    first_name = $('#user_first_name').val().trim();
    last_name = $('#user_last_name').val().trim();
    gender = $('#user_gender').find(':selected').val();
    birthday = $('#user_birthday').val().trim();
    phone_number = $('#user_phone_number').val().trim();
    apartment_number = $('#user_apartment_number').val().trim();
    street = $('#user_street').val().trim();
    ward = $('#user_ward').val().trim();
    district = $('#user_district').val().trim();
    province = $('#user_province').val().trim();
    if(last_name == ''|| phone_number == ''){
        alert('Please fill in your personal information');
    }
    else{
        $.ajax({
            url: '/users/update-user-information',
            type: 'patch',
            data: {
                user: {
                    first_name: first_name,
                    last_name: last_name,
                    gender: gender,
                    birthday: birthday,
                    phone_number: phone_number,
                    apartment_number: apartment_number,
                    street: street,
                    ward: ward,
                    district: district,
                    province: province,
                }
            },
            success: function(data){
                if(data.is_signed_in){
                    if(data.is_update_success){
                        alert('Update your information success');
                    }
                    else{
                        alert('Update your information failed');
                    }
                }
                else{
                    $('#sign-in').modal('show');
                }
            }        
        });
    }
}
function update_user_password(){
    new_password = $('#user_new_password').val();
    if(new_password == ''){
        alert('Please fill in your new password');
    }
    else{
        $.ajax({
            url: '/users/update-user-password',
            type: 'patch',
            data: {
                user: {
                    password: new_password
                }
            },
            success: function(data){
                if(data.is_signed_in){
                    if(data.is_update_success){
                        $('#user_new_password').val('');
                        alert('Update your password success. Please sign in again!');
                        window.location.href = '/'
                    }
                    else{
                        alert(data.message);
                    }
                }
                else{
                    $('#sign-in').modal('show');
                }
            }        
        });
    }
}
function change_avatar(){
    $('#fileUpload').trigger('click');
}
function update_avatar () {
    if ($('#fileUpload').val().length != 0) {
        var fileUpload = $('#fileUpload').get(0);
        var files = fileUpload.files;
        var formData = new FormData();
        formData.append('file', files[0]);
        $.ajax(
            {
                type: 'post',
                url: '/users/update-avatar',
                contentType: false,
                processData: false,
                data: formData,
                success: function (data) {
                    if(data.is_signed_in){
                        if(data.is_update_success){
                            $('#user_avatar').attr('src', data.avatar_url);
                            alert('Update your avatar success!');
                        }
                        else{
                            alert(data.message);
                        }
                    }
                    else{
                        $('#sign-in').modal('show');
                    }
                }
            });
    }
}