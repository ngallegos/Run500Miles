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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120109000251) do

  create_table "activities", :force => true do |t|
    t.string   "comment"
    t.integer  "user_id"
    t.date     "activity_date"
    t.float    "distance"
    t.integer  "hours"
    t.integer  "minutes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "location"
    t.integer  "activity_type"
  end

  create_table "configurations", :force => true do |t|
    t.string   "key"
    t.text     "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string    "email"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.string    "fname"
    t.string    "lname"
    t.string    "encrypted_password"
    t.string    "salt"
    t.boolean   "admin",              :default => false
    t.string    "user_type",          :default => "2"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["user_type"], :name => "index_users_on_user_type"

end
