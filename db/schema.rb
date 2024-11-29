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

ActiveRecord::Schema[7.1].define(version: 2024_11_29_084156) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "follow_requests", force: :cascade do |t|
    t.bigint "recipient_id", null: false
    t.bigint "sender_id", null: false
    t.string "status", default: "pending"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recipient_id"], name: "index_follow_requests_on_recipient_id"
    t.index ["sender_id"], name: "index_follow_requests_on_sender_id"
  end

  create_table "tandas", force: :cascade do |t|
    t.integer "goal_amount"
    t.integer "creator_id"
    t.string "name"
    t.datetime "due_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "creator_wallet"
  end

  create_table "transactions", force: :cascade do |t|
    t.integer "user_tanda_id"
    t.integer "amount"
    t.datetime "date"
    t.string "description"
    t.string "transaction_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_tandas", force: :cascade do |t|
    t.integer "tanda_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "first_name"
    t.string "last_name"
    t.string "username"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "default_address"
    t.decimal "balance", precision: 10, scale: 2, default: "0.0"
    t.json "wallet_data"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "follow_requests", "users", column: "recipient_id"
  add_foreign_key "follow_requests", "users", column: "sender_id"
end
