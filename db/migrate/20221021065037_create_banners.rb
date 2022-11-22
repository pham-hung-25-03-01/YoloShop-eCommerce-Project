class CreateBanners < ActiveRecord::Migration[7.0]
  def change
    create_table :banners, id: :uuid, default: 'gen_random_uuid()' do |t|
      t.uuid :event_id, null: false
      t.uuid :admin_user_id, null: false
      t.text :banner_url, null: false, unique: true
      t.datetime :created_at, null: false, default: -> { 'now()' }
    end
  end
end
