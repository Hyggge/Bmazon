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

ActiveRecord::Schema[7.0].define(version: 2023_01_01_125103) do
  create_table "articles", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comments", force: :cascade do |t|
    t.integer "grade"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
  end

  create_table "params", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "replies", force: :cascade do |t|
    t.integer "floor"
    t.string "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  add_foreign_key "shop_managements", "shops"
  add_foreign_key "shop_managements", "users"
  add_foreign_key "shops", "images"
  add_foreign_key "shops", "users", column: "owner_id"
  add_foreign_key "users", "images"
  add_foreign_key "users", "students"
end
