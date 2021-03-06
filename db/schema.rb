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

ActiveRecord::Schema.define(version: 20170719190439) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "contact_messages", force: :cascade do |t|
    t.string   "email",      null: false
    t.text     "message",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_contact_messages_on_email", using: :btree
  end

  create_table "currencies", force: :cascade do |t|
    t.string   "code",       null: false
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_currencies_on_code", unique: true, using: :btree
  end

  create_table "expense_types", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_expense_types_on_name", unique: true, using: :btree
  end

  create_table "expenses", force: :cascade do |t|
    t.integer  "project_id",                              null: false
    t.integer  "payment_type_id"
    t.integer  "expense_type_id"
    t.integer  "currency_id"
    t.date     "expense_date"
    t.decimal  "amount",          precision: 8, scale: 2
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.index ["currency_id"], name: "index_expenses_on_currency_id", using: :btree
    t.index ["expense_type_id"], name: "index_expenses_on_expense_type_id", using: :btree
    t.index ["payment_type_id"], name: "index_expenses_on_payment_type_id", using: :btree
    t.index ["project_id"], name: "index_expenses_on_project_id", using: :btree
  end

  create_table "payment_types", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_payment_types_on_name", unique: true, using: :btree
  end

  create_table "projects", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                         null: false
    t.string   "name",                          null: false
    t.string   "password_hash",                 null: false
    t.string   "password_salt",                 null: false
    t.boolean  "admin",         default: false
    t.boolean  "active",        default: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["name"], name: "index_users_on_name", unique: true, using: :btree
  end

  add_foreign_key "expenses", "currencies"
  add_foreign_key "expenses", "expense_types"
  add_foreign_key "expenses", "payment_types"
  add_foreign_key "expenses", "projects"
  add_foreign_key "projects", "users"
end
