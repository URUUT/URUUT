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

ActiveRecord::Schema.define(:version => 20130217062644) do

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "donations", :force => true do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.float    "amount"
    t.string   "customer_token"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.string   "email"
  end

  create_table "galleries", :force => true do |t|
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.string   "gallery_file_name"
    t.string   "gallery_content_type"
    t.integer  "gallery_file_size"
    t.datetime "gallery_updated_at"
    t.integer  "project_id"
  end

  create_table "perks", :force => true do |t|
    t.string   "name"
    t.float    "amount"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "project_id"
  end

  create_table "projects", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "location"
    t.string   "duration"
    t.string   "goal"
    t.string   "category"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.string   "video"
    t.string   "tags"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "user_id"
    t.boolean  "deleted",            :default => false
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.integer  "zip"
    t.string   "neighborhood"
    t.boolean  "live",               :default => false
    t.text     "short_description"
    t.string   "bitly"
    t.string   "project_token"
    t.string   "status"
    t.string   "website"
    t.string   "facebook_page"
    t.string   "twitter_handle"
    t.string   "organization"
    t.string   "large_image"
    t.string   "story"
    t.string   "about"
    t.string   "approval_date"
  end

  create_table "services", :force => true do |t|
    t.string  "uid"
    t.string  "provider"
    t.integer "user_id"
  end

  add_index "services", ["user_id"], :name => "index_services_on_user_id"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "sponsors", :force => true do |t|
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "name"
  end

  add_index "sponsors", ["email"], :name => "index_sponsors_on_email", :unique => true
  add_index "sponsors", ["reset_password_token"], :name => "index_sponsors_on_reset_password_token", :unique => true

  create_table "users", :force => true do |t|
    t.string   "email",                      :default => "",    :null => false
    t.string   "encrypted_password",         :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",              :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
    t.string   "name"
    t.string   "website"
    t.string   "project_image_file_name"
    t.string   "project_image_content_type"
    t.integer  "project_image_file_size"
    t.datetime "project_image_updated_at"
    t.string   "project_video_file_name"
    t.string   "project_video_content_type"
    t.integer  "project_video_file_size"
    t.datetime "project_video_updated_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.boolean  "municipality",               :default => false
    t.string   "city"
    t.string   "state"
    t.integer  "zip"
    t.string   "neighborhood"
    t.string   "provider"
    t.string   "uid"
    t.string   "token"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
