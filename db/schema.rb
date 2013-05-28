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

ActiveRecord::Schema.define(:version => 20130528052919) do

  create_table "badges_sashes", :force => true do |t|
    t.integer  "badge_id"
    t.integer  "sash_id"
    t.boolean  "notified_user", :default => false
    t.datetime "created_at"
  end

  add_index "badges_sashes", ["badge_id", "sash_id"], :name => "index_badges_sashes_on_badge_id_and_sash_id"
  add_index "badges_sashes", ["badge_id"], :name => "index_badges_sashes_on_badge_id"
  add_index "badges_sashes", ["sash_id"], :name => "index_badges_sashes_on_sash_id"

  create_table "contacts", :force => true do |t|
    t.string   "email"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

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
    t.integer "user_id"
    t.integer "project_id"
    t.float   "amount"
    t.string  "customer_token"
    t.string  "email"
  end

  create_table "galleries", :force => true do |t|
    t.string   "gallery_file_name"
    t.string   "gallery_content_type"
    t.integer  "gallery_file_size"
    t.datetime "gallery_updated_at"
    t.integer  "project_id"
  end

  create_table "identities", :force => true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "token"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "merit_actions", :force => true do |t|
    t.integer  "user_id"
    t.string   "action_method"
    t.integer  "action_value"
    t.boolean  "had_errors",    :default => false
    t.string   "target_model"
    t.integer  "target_id"
    t.boolean  "processed",     :default => false
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  create_table "merit_activity_logs", :force => true do |t|
    t.integer  "action_id"
    t.string   "related_change_type"
    t.integer  "related_change_id"
    t.string   "description"
    t.datetime "created_at"
  end

  create_table "merit_score_points", :force => true do |t|
    t.integer  "score_id"
    t.integer  "num_points", :default => 0
    t.string   "log"
    t.datetime "created_at"
  end

  create_table "merit_scores", :force => true do |t|
    t.integer "sash_id"
    t.string  "category", :default => "default"
  end

  create_table "newsletters", :force => true do |t|
    t.string   "email"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "perks", :force => true do |t|
    t.string  "name"
    t.float   "amount"
    t.text    "description"
    t.integer "project_id"
  end

  create_table "project_sponsors", :force => true do |t|
    t.string  "card_token"
    t.float   "cost"
    t.text    "logo"
    t.text    "mission"
    t.string  "name"
    t.integer "project_id"
    t.integer "sponsor_id"
    t.string  "payment",    :default => "Unpaid"
    t.string  "status",     :default => "Unconfirmed"
    t.integer "level_id"
    t.string  "card_type"
    t.integer "card_last4"
  end

  create_table "projects", :force => true do |t|
    t.string  "title"
    t.text    "description"
    t.string  "location"
    t.string  "duration"
    t.string  "goal"
    t.string  "category"
    t.integer "user_id"
    t.integer "deleted"
    t.string  "address"
    t.string  "city"
    t.string  "state"
    t.string  "zip"
    t.string  "neighborhood"
    t.integer "live"
    t.text    "short_description"
    t.string  "bitly"
    t.string  "project_token"
    t.string  "status"
    t.string  "website"
    t.string  "facebook_page"
    t.string  "twitter_handle"
    t.string  "organization"
    t.string  "large_image"
    t.text    "story"
    t.text    "about"
    t.string  "approval_date"
    t.string  "project_title"
    t.integer "ready_for_approval"
    t.string  "seed_image"
    t.string  "cultivation_image"
    t.string  "organization_type"
    t.string  "organization_classification"
    t.string  "publishable_key"
    t.string  "seed_video"
    t.string  "cultivation_video"
    t.string  "seed_mime_type",              :default => "image"
    t.string  "cultivation_mime_type",       :default => "image"
  end

  create_table "sashes", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "services", :force => true do |t|
    t.string  "uid"
    t.string  "provider"
    t.integer "user_id"
  end

  create_table "sessions", :force => true do |t|
    t.string "session_id"
    t.text   "data"
  end

  create_table "sponsors", :force => true do |t|
    t.string "payment_type"
    t.string "name"
    t.string "email"
    t.string "phone"
    t.string "token"
  end

  create_table "sponsorship_benefits", :force => true do |t|
    t.string   "name"
    t.integer  "sponsorship_level_id"
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
    t.integer  "project_id"
    t.boolean  "status",               :default => false
    t.string   "sponsorship_level"
    t.integer  "cost"
  end

  create_table "sponsorship_levels", :force => true do |t|
    t.string   "name"
    t.float    "cost"
    t.text     "description"
    t.integer  "required"
    t.integer  "funding_goal"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "",                           :null => false
    t.string   "encrypted_password",     :default => "",                           :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "first_name"
    t.string   "website"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "neighborhood"
    t.string   "provider"
    t.string   "uid"
    t.string   "token"
    t.string   "organization"
    t.text     "mission"
    t.boolean  "subscribed"
    t.string   "avatar",                 :default => "/images/default-avatar.png"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "confirmation_token"
    t.string   "last_name"
    t.integer  "sash_id"
    t.integer  "level",                  :default => 0
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
