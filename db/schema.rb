# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_10_21_082737) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "admins", primary_key: "admin_id", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "role_id", null: false
    t.text "first_name"
    t.text "last_name"
    t.text "avatar_url"
    t.datetime "birthday", null: false
    t.string "phone_number", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.boolean "status", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "created_by", null: false
    t.uuid "updated_by", null: false
    t.boolean "is_actived", default: true, null: false
    t.datetime "deleted_at"
    t.uuid "deleted_by"
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "ages", primary_key: "age_id", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "age_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "created_by", null: false
    t.uuid "updated_by", null: false
    t.boolean "is_actived", default: true, null: false
    t.datetime "deleted_at"
    t.uuid "deleted_by"
  end

  create_table "banners", primary_key: "banner_id", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "event_id", null: false
    t.uuid "admin_id", null: false
    t.text "banner_url", null: false
    t.datetime "created_at", default: -> { "now()" }, null: false
  end

  create_table "categories", primary_key: "category_id", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "category_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "created_by", null: false
    t.uuid "updated_by", null: false
    t.boolean "is_actived", default: true, null: false
    t.datetime "deleted_at"
    t.uuid "deleted_by"
  end

  create_table "comments", primary_key: "comment_id", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "product_id", null: false
    t.uuid "user_id", null: false
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "updated_by", null: false
    t.boolean "is_actived", default: true, null: false
    t.datetime "deleted_at"
    t.uuid "deleted_by"
  end

  create_table "coupons", primary_key: "coupon_id", id: :string, force: :cascade do |t|
    t.datetime "start_date", default: -> { "now()" }, null: false
    t.datetime "end_date", null: false
    t.float "coupon_discount", default: 0.0, null: false
    t.integer "number_of_uses", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "created_by", null: false
    t.uuid "updated_by", null: false
    t.boolean "is_actived", default: true, null: false
    t.datetime "deleted_at"
    t.uuid "deleted_by"
  end

  create_table "events", primary_key: "event_id", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "event_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "created_by", null: false
    t.uuid "updated_by", null: false
    t.boolean "is_actived", default: true, null: false
    t.datetime "deleted_at"
    t.uuid "deleted_by"
  end

  create_table "inventories", primary_key: "inventory_id", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "product_id", null: false
    t.string "size", null: false
    t.text "color_url", null: false
    t.integer "quantity_of_inventory", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "created_by", null: false
    t.uuid "updated_by", null: false
    t.boolean "is_actived", default: true, null: false
    t.datetime "deleted_at"
    t.uuid "deleted_by"
  end

  create_table "inventory_quantity_logs", primary_key: "inventory_quantity_log_id", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "inventory_id", null: false
    t.uuid "admin_id", null: false
    t.integer "quantity_of_import", default: 0, null: false
    t.integer "quantity_of_export", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "updated_by", null: false
    t.boolean "is_actived", default: true, null: false
    t.datetime "deleted_at"
    t.uuid "deleted_by"
  end

  create_table "invoices", primary_key: "invoice_id", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "order_id", null: false
    t.uuid "admin_id", null: false
    t.uuid "payment_id", null: false
    t.string "bank_code"
    t.string "bank_transaction_no"
    t.string "transaction_no"
    t.money "total_money", scale: 2, null: false
    t.money "total_money_discount", scale: 2, null: false
    t.money "total_money_payment", scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "updated_by", null: false
    t.boolean "is_actived", default: true, null: false
    t.datetime "deleted_at"
    t.uuid "deleted_by"
  end

  create_table "order_details", primary_key: ["inventory_id", "order_id"], force: :cascade do |t|
    t.uuid "inventory_id", null: false
    t.uuid "order_id", null: false
    t.integer "quantity_of_order", null: false
    t.money "sell_price", scale: 2, null: false
    t.float "product_discount", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "created_by", null: false
    t.uuid "updated_by", null: false
    t.boolean "is_actived", default: true, null: false
    t.datetime "deleted_at"
    t.uuid "deleted_by"
  end

  create_table "orders", primary_key: "order_id", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.string "coupon_id"
    t.datetime "ship_date"
    t.text "apartment_number", null: false
    t.text "street", null: false
    t.text "ward", null: false
    t.text "district", null: false
    t.text "province", null: false
    t.integer "status", limit: 2, default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "updated_by", null: false
    t.boolean "is_actived", default: true, null: false
    t.datetime "deleted_at"
    t.uuid "deleted_by"
  end

  create_table "payments", primary_key: "payment_id", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "payment_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "created_by", null: false
    t.uuid "updated_by", null: false
    t.boolean "is_actived", default: true, null: false
    t.datetime "deleted_at"
    t.uuid "deleted_by"
  end

  create_table "permissions", primary_key: "permission_id", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "permission_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "created_by", null: false
    t.uuid "updated_by", null: false
    t.boolean "is_actived", default: true, null: false
    t.datetime "deleted_at"
    t.uuid "deleted_by"
  end

  create_table "product_groups", primary_key: "product_group_id", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "product_group_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "created_by", null: false
    t.uuid "updated_by", null: false
    t.boolean "is_actived", default: true, null: false
    t.datetime "deleted_at"
    t.uuid "deleted_by"
  end

  create_table "product_images", primary_key: "product_image_id", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "product_id", null: false
    t.text "image_url", null: false
    t.datetime "created_at", default: -> { "now()" }, null: false
    t.uuid "created_by", null: false
  end

  create_table "product_price_logs", primary_key: "product_price_log_id", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "admin_id", null: false
    t.uuid "product_id", null: false
    t.money "import_price", scale: 2, default: "0.0", null: false
    t.money "sell_price", scale: 2, default: "0.0", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "updated_by", null: false
    t.boolean "is_actived", default: true, null: false
    t.datetime "deleted_at"
    t.uuid "deleted_by"
  end

  create_table "products", primary_key: "product_id", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "event_id"
    t.uuid "supplier_id", null: false
    t.uuid "product_group_id", null: false
    t.uuid "category_id", null: false
    t.uuid "age_id", null: false
    t.text "product_name", null: false
    t.text "meta_title", null: false
    t.text "origin"
    t.text "description"
    t.boolean "gender", null: false
    t.integer "warranty", default: 0, null: false
    t.money "import_price", scale: 2, default: "0.0", null: false
    t.money "sell_price", scale: 2, default: "0.0", null: false
    t.float "product_discount", default: 0.0, null: false
    t.integer "shipping", default: 1, null: false
    t.float "score_rating", default: 0.0, null: false
    t.integer "number_of_rates", default: 0, null: false
    t.boolean "is_available", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "created_by", null: false
    t.uuid "updated_by", null: false
    t.boolean "is_actived", default: true, null: false
    t.datetime "deleted_at"
    t.uuid "deleted_by"
  end

  create_table "reviews", primary_key: ["product_id", "user_id"], force: :cascade do |t|
    t.uuid "product_id", null: false
    t.uuid "user_id", null: false
    t.float "user_score_rating"
    t.boolean "is_favored", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "updated_by", null: false
  end

  create_table "role_details", primary_key: ["permission_id", "role_id"], force: :cascade do |t|
    t.uuid "permission_id", null: false
    t.uuid "role_id", null: false
    t.datetime "created_at", default: -> { "now()" }, null: false
    t.uuid "created_by", null: false
    t.boolean "is_actived", default: true, null: false
    t.datetime "deleted_at"
    t.uuid "deleted_by"
  end

  create_table "roles", primary_key: "role_id", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "role_name", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "created_by", null: false
    t.uuid "updated_by", null: false
    t.boolean "is_actived", default: true, null: false
    t.datetime "deleted_at"
    t.uuid "deleted_by"
  end

  create_table "suppliers", primary_key: "supplier_id", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "supplier_name", null: false
    t.datetime "contract_date", default: -> { "now()" }, null: false
    t.string "phone_number"
    t.string "email"
    t.text "address"
    t.boolean "is_cooperated", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "created_by", null: false
    t.uuid "updated_by", null: false
    t.boolean "is_actived", default: true, null: false
    t.datetime "deleted_at"
    t.uuid "deleted_by"
  end

  create_table "users", primary_key: "user_id", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "first_name"
    t.text "last_name"
    t.text "avatar_url"
    t.boolean "gender", null: false
    t.datetime "birthday", null: false
    t.string "phone_number", null: false
    t.text "apartment_number", null: false
    t.text "street", null: false
    t.text "ward", null: false
    t.text "district", null: false
    t.text "province", null: false
    t.string "provider"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.boolean "status", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "updated_by", null: false
    t.boolean "is_actived", default: true, null: false
    t.datetime "deleted_at"
    t.uuid "deleted_by"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "admins", "roles", primary_key: "role_id", name: "admins_role_id_fkey"
  add_foreign_key "banners", "admins", primary_key: "admin_id", name: "banners_admin_id_fkey"
  add_foreign_key "banners", "events", primary_key: "event_id", name: "banners_event_id_fkey"
  add_foreign_key "comments", "products", primary_key: "product_id", name: "comments_product_id_fkey"
  add_foreign_key "comments", "users", primary_key: "user_id", name: "comments_user_id_fkey"
  add_foreign_key "inventories", "products", primary_key: "product_id", name: "inventories_product_id_fkey"
  add_foreign_key "inventory_quantity_logs", "admins", primary_key: "admin_id", name: "inventory_quantity_logs_admin_id_fkey"
  add_foreign_key "inventory_quantity_logs", "inventories", primary_key: "inventory_id", name: "inventory_quantity_logs_inventory_id_fkey"
  add_foreign_key "invoices", "admins", primary_key: "admin_id", name: "invoices_admin_id_fkey"
  add_foreign_key "invoices", "orders", primary_key: "order_id", name: "invoices_order_id_fkey"
  add_foreign_key "invoices", "payments", primary_key: "payment_id", name: "invoices_payment_id_fkey"
  add_foreign_key "order_details", "inventories", primary_key: "inventory_id", name: "order_details_inventory_id_fkey"
  add_foreign_key "order_details", "orders", primary_key: "order_id", name: "order_details_order_id_fkey"
  add_foreign_key "orders", "coupons", primary_key: "coupon_id", name: "orders_coupon_id_fkey"
  add_foreign_key "orders", "users", primary_key: "user_id", name: "orders_user_id_fkey"
  add_foreign_key "product_images", "products", primary_key: "product_id", name: "product_images_product_id_fkey"
  add_foreign_key "product_price_logs", "admins", primary_key: "admin_id", name: "product_price_logs_admin_id_fkey"
  add_foreign_key "product_price_logs", "products", primary_key: "product_id", name: "product_price_logs_product_id_fkey"
  add_foreign_key "products", "ages", primary_key: "age_id", name: "products_age_id_fkey"
  add_foreign_key "products", "categories", primary_key: "category_id", name: "products_category_id_fkey"
  add_foreign_key "products", "events", primary_key: "event_id", name: "products_event_id_fkey"
  add_foreign_key "products", "product_groups", primary_key: "product_group_id", name: "products_product_group_id_fkey"
  add_foreign_key "products", "suppliers", primary_key: "supplier_id", name: "products_supplier_id_fkey"
  add_foreign_key "reviews", "products", primary_key: "product_id", name: "reviews_product_id_fkey"
  add_foreign_key "reviews", "users", primary_key: "user_id", name: "reviews_user_id_fkey"
  add_foreign_key "role_details", "permissions", primary_key: "permission_id", name: "role_details_permission_id_fkey"
  add_foreign_key "role_details", "roles", primary_key: "role_id", name: "role_details_role_id_fkey"
end
