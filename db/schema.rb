# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_09_08_103219) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "balances", force: :cascade do |t|
    t.integer "user_id"
    t.decimal "main_balance"
    t.decimal "balance_added"
    t.decimal "balance_deducted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "circulars", force: :cascade do |t|
    t.text "note"
    t.date "published_at"
    t.boolean "published", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "holidays", force: :cascade do |t|
    t.date "date"
    t.string "occasion"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "leave_days", force: :cascade do |t|
    t.integer "leave_id"
    t.date "date"
    t.string "leave_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "leaves", force: :cascade do |t|
    t.integer "user_id"
    t.date "start_date"
    t.date "end_date"
    t.text "description"
    t.string "status", default: "pending"
    t.string "reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "deleted", default: false
    t.text "days"
    t.integer "placed_by_id"
    t.integer "status_updated_by_id"
    t.integer "sent_notification_count", default: 0
  end

  create_table "review_requests", force: :cascade do |t|
    t.integer "user_id"
    t.integer "reviewer_id"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reviews", force: :cascade do |t|
    t.integer "user_id"
    t.integer "reviewer_id"
    t.text "feedback"
    t.decimal "rating"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "mobile"
    t.integer "role", default: 0
    t.boolean "deleted", default: false
    t.integer "employee_id"
    t.integer "manager_id"
    t.date "joining_date"
    t.string "image"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
