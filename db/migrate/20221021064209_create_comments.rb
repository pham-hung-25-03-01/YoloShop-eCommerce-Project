class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments, id: false, primary_key: :comment_id do |t|
      t.uuid :comment_id, primary_key: true, null: false, default: 'gen_random_uuid()'
      t.uuid :product_id, null: false
      t.uuid :user_id, null: false
      t.text :content, null: false

      t.timestamps
      t.uuid :updated_by, null: false
      t.boolean :is_actived, null: false, default: true
      t.datetime :deleted_at
      t.uuid :deleted_by
    end
  end
end
