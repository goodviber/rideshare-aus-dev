# encoding: UTF-8
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

ActiveRecord::Schema.define(:version => 20110928113709) do

  create_table "authentications", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "demos", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "locations", :force => true do |t|
    t.string   "name",             :limit => 200
    t.string   "ascii_name",       :limit => 200
    t.string   "alternate_names",  :limit => 5000
    t.string   "latitude",         :limit => 1000
    t.string   "longitude",        :limit => 1000
    t.string   "feature_class",    :limit => 1
    t.string   "feature_code",     :limit => 10
    t.string   "country_code",     :limit => 10
    t.string   "cc2",              :limit => 2000
    t.string   "admin1_code",      :limit => 20
    t.string   "admin2_code",      :limit => 80
    t.string   "admin3_code",      :limit => 20
    t.string   "admin4_code",      :limit => 20
    t.integer  "population"
    t.integer  "elevation"
    t.integer  "gtopo30"
    t.string   "timezone",         :limit => 1000
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "trips_from_count",                 :default => 0
    t.integer  "trips_to_count",                   :default => 0
  end

  create_table "queued_posts", :id => false, :force => true do |t|
    t.string   "page_id"
    t.string   "post_id"
    t.string   "fb_id"
    t.text     "message"
    t.datetime "post_created_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "trips", :force => true do |t|
    t.integer  "to_location_id"
    t.integer  "from_location_id"
    t.integer  "seats",            :limit => 2,                                  :default => 0, :null => false
    t.integer  "driver_id",                                                                     :null => false
    t.date     "trip_date"
    t.time     "trip_time"
    t.string   "time_of_day"
    t.integer  "rel_trip_id"
    t.decimal  "trip_distance",                   :precision => 18, :scale => 4
    t.time     "trip_duration"
    t.string   "fb_post_id",       :limit => 500
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "trip_details"
    t.integer  "cost",                                                           :default => 0
  end

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "city"
    t.string   "gender",                 :limit => 1
    t.date     "dob"
    t.datetime "last_login"
    t.date     "account_expire_on"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
