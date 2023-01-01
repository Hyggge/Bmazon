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

ActiveRecord::Schema[7.0].define(version: 2023_01_01_161550) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "articles", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "commodity_id"
    t.integer "author_id", null: false
    t.index ["author_id"], name: "index_articles_on_author_id"
    t.index ["commodity_id"], name: "index_articles_on_commodity_id"
  end

  create_table "collects", force: :cascade do |t|
    t.integer "commodity_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["commodity_id"], name: "index_collects_on_commodity_id"
    t.index ["user_id"], name: "index_collects_on_user_id"
  end

  create_table "comments", force: :cascade do |t|
    t.integer "grade"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "order_id", null: false
    t.index ["order_id"], name: "index_comments_on_order_id"
  end

  create_table "commodities", force: :cascade do |t|
    t.string "name"
    t.text "introduction"
    t.integer "status"
    t.integer "total"
    t.integer "sale"
    t.decimal "price", precision: 10, scale: 2
    t.integer "method"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "shop_id", null: false
    t.integer "image_id", null: false
    t.index ["image_id"], name: "index_commodities_on_image_id"
    t.index ["shop_id"], name: "index_commodities_on_shop_id"
  end

  create_table "images", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "options", force: :cascade do |t|
    t.string "description"
    t.decimal "add"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "param_id", null: false
    t.index ["param_id"], name: "index_options_on_param_id"
  end

  create_table "order_option_maps", force: :cascade do |t|
    t.integer "order_id", null: false
    t.integer "option_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["option_id"], name: "index_order_option_maps_on_option_id"
    t.index ["order_id"], name: "index_order_option_maps_on_order_id"
  end

  create_table "orders", force: :cascade do |t|
    t.integer "status"
    t.decimal "price", precision: 10, scale: 2
    t.integer "num"
    t.string "address"
    t.text "note"
    t.datetime "pay_time"
    t.datetime "confirm_time"
    t.datetime "close_time"
    t.datetime "deliver_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "commodity_id", null: false
    t.integer "user_id", null: false
    t.index ["commodity_id"], name: "index_orders_on_commodity_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "params", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "commodity_id", null: false
    t.index ["commodity_id"], name: "index_params_on_commodity_id"
  end

  create_table "replies", force: :cascade do |t|
    t.integer "floor"
    t.string "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "article_id", null: false
    t.integer "refer_id"
    t.integer "user_id", null: false
    t.index ["article_id"], name: "index_replies_on_article_id"
    t.index ["refer_id"], name: "index_replies_on_refer_id"
    t.index ["user_id"], name: "index_replies_on_user_id"
  end

  create_table "shop_managements", force: :cascade do |t|
    t.integer "shop_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shop_id"], name: "index_shop_managements_on_shop_id"
    t.index ["user_id"], name: "index_shop_managements_on_user_id"
  end

  create_table "shops", force: :cascade do |t|
    t.string "name"
    t.text "introduction"
    t.integer "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "image_id"
    t.integer "owner_id", null: false
    t.index ["image_id"], name: "index_shops_on_image_id"
    t.index ["owner_id"], name: "index_shops_on_owner_id"
  end

  create_table "students", force: :cascade do |t|
    t.string "name"
    t.integer "depart"
    t.integer "attendance_year"
    t.integer "gender"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "email"
    t.string "password_digest"
    t.string "phone_no"
    t.string "signature"
    t.integer "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "student_id"
    t.integer "image_id"
    t.index ["image_id"], name: "index_users_on_image_id"
    t.index ["student_id"], name: "index_users_on_student_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "articles", "commodities"
  add_foreign_key "articles", "users", column: "author_id"
  add_foreign_key "collects", "commodities"
  add_foreign_key "collects", "users"
  add_foreign_key "comments", "orders"
  add_foreign_key "commodities", "images"
  add_foreign_key "commodities", "shops"
  add_foreign_key "options", "params"
  add_foreign_key "order_option_maps", "options"
  add_foreign_key "order_option_maps", "orders"
  add_foreign_key "orders", "commodities"
  add_foreign_key "orders", "users"
  add_foreign_key "params", "commodities"
  add_foreign_key "replies", "articles"
  add_foreign_key "replies", "replies", column: "refer_id"
  add_foreign_key "replies", "users"
  add_foreign_key "shop_managements", "shops"
  add_foreign_key "shop_managements", "users"
  add_foreign_key "shops", "images"
  add_foreign_key "shops", "users", column: "owner_id"
  add_foreign_key "users", "images"
  add_foreign_key "users", "students"
end
