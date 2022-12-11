class SeedData < ActiveRecord::Migration[7.0]
  def change
    execute "INSERT INTO admin_users(id, first_name, last_name, avatar_url, birthday, phone_number, email, encrypted_password, permission, created_at, updated_at, updated_by)
            VALUES ('1fd95dfd-632d-466b-9a41-f8ca4a79d7f0', '', 'admin', 'https://res.cloudinary.com/dlzgqgu4l/image/upload/v1670770425/IMG_20221116_215041_brjgtg.jpg', '25/03/2001', '0898759325', 'phamhunggl721@gmail.com', '$2a$12$vzLnhFqt9HNLvCOTlT71tOUei.vlklfeQ1pAtzbM6hxlybhMayzMW', 1, '01/12/2022', '01/12/2022', '1fd95dfd-632d-466b-9a41-f8ca4a79d7f0');"
    execute "INSERT INTO payments(id, payment_name, created_at, updated_at, created_by, updated_by, is_actived)
            VALUES ('ab002207-dd09-424c-95c9-57d0da72d632', 'VNPay e - wallet', '01/12/2022', '01/12/2022', '1fd95dfd-632d-466b-9a41-f8ca4a79d7f0', '1fd95dfd-632d-466b-9a41-f8ca4a79d7f0', true);"
    execute "INSERT INTO payments(id, payment_name, created_at, updated_at, created_by, updated_by, is_actived)
            VALUES ('f0790e0b-15f2-4bae-a9a3-87fe0017ca9c', 'COD - Cash On Delivery', '01/12/2022', '01/12/2022', '1fd95dfd-632d-466b-9a41-f8ca4a79d7f0', '1fd95dfd-632d-466b-9a41-f8ca4a79d7f0', true);"
  end
end
