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

ActiveRecord::Schema[7.2].define(version: 2012_01_09_000251) do
  create_table "activities", force: :cascade do |t|
    t.string "comment"
    t.integer "user_id"
    t.date "activity_date"
    t.float "distance"
    t.integer "hours"
    t.integer "minutes"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "location", default: ""
    t.integer "activity_type"
    t.index ["user_id", "created_at"], name: "index_activities_on_user_id_and_created_at"
  end

  create_table "configurations", force: :cascade do |t|
    t.string "key"
    t.text "value"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "users", force: :cascade do |t|
    t.string "fname"
    t.string "lname"
    t.string "email"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "encrypted_password"
    t.string "salt"
    t.boolean "admin", default: false
    t.string "user_type", default: "2"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["user_type"], name: "index_users_on_user_type"
  end
end
