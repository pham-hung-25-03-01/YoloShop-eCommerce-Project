class CreateReviews < ActiveRecord::Migration[7.0]
  def change
    create_table :reviews, id: false, primary_key: [:product_id, :user_id] do |t|
      t.uuid :product_id, null: false
      t.uuid :user_id, null: false
      t.float :user_score_rating
      t.boolean :is_favored, null: false, default: false

      t.timestamps
      t.string :updated_by, null: false
    end
    execute 'ALTER TABLE reviews ADD PRIMARY KEY (product_id, user_id);'
  end
end
