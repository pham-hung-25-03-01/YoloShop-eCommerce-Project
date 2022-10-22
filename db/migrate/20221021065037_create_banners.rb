class CreateBanners < ActiveRecord::Migration[7.0]
  def change
    create_table :banners, id: false, primary_key: :banner_id do |t|
      t.uuid :banner_id, primary_key: true, null: false, default: 'gen_random_uuid()'
      t.uuid :event_id, null: false
      t.uuid :admin_id, null: false
      t.text :banner_url, null: false, unique: true
      t.datetime :created_at, null: false, default: -> { 'now()' }
    end
  end
end
