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

ActiveRecord::Schema.define(:version => 20130921045013) do

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
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
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

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

  create_table "documents", :force => true do |t|
    t.string   "filename"
    t.integer  "project_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "url"
  end

  create_table "donations", :force => true do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.float    "amount"
    t.string   "customer_token"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "perk_name"
    t.boolean  "confirmed",      :default => false
    t.text     "description"
    t.boolean  "anonymous",      :default => false
  end

  create_table "filter_types", :force => true do |t|
    t.string   "name"
    t.string   "display_name"
    t.decimal  "price"
    t.integer  "suggested_replacement_time"
    t.text     "description"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.string   "image_url"
  end

  add_index "filter_types", ["name"], :name => "index_filter_types_on_name"

  create_table "filters", :force => true do |t|
    t.integer  "subscription_id"
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
    t.integer  "quantity"
    t.integer  "thickness"
    t.decimal  "temp_width",      :precision => 10, :scale => 1
    t.decimal  "temp_length",     :precision => 10, :scale => 1
    t.decimal  "width",           :precision => 10, :scale => 1
    t.decimal  "length",          :precision => 10, :scale => 1
  end

  add_index "filters", ["subscription_id"], :name => "index_filters_on_subscription_id"

  create_table "fulfillment_orders", :force => true do |t|
    t.integer  "subscription_id"
    t.string   "stripe_charge_id"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
    t.string   "sent_to_manufacturing"
    t.string   "sent_to_fulfillment"
    t.string   "street"
    t.string   "street2"
    t.string   "city"
    t.string   "state"
    t.string   "zipcode"
    t.integer  "filter_type_id"
    t.float    "total"
  end

  create_table "galleries", :force => true do |t|
    t.string   "gallery_file_name"
    t.string   "gallery_content_type"
    t.datetime "gallery_updated_at"
    t.integer  "project_id"
    t.string   "gallery_type"
    t.string   "thumbnail_url"
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

  create_table "milestoneemails", :force => true do |t|
    t.boolean  "fifteen_percent"
    t.boolean  "fifty_percent"
    t.boolean  "seventy_five_percent"
    t.boolean  "ninety_percent"
    t.integer  "project_id"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
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
    t.boolean "limit",           :default => false
    t.string  "perks_available"
    t.integer "perk_limit"
  end

  create_table "posts", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "press_coverages", :force => true do |t|
    t.string   "title"
    t.string   "link"
    t.date     "release_date"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "publication"
  end

  create_table "press_releases", :force => true do |t|
    t.string   "title"
    t.string   "link"
    t.string   "release_date"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "project_sponsors", :force => true do |t|
    t.string   "card_token"
    t.float    "cost"
    t.text     "logo"
    t.text     "mission"
    t.string   "name"
    t.integer  "project_id"
    t.integer  "sponsor_id"
    t.string   "payment",      :default => "Unpaid"
    t.string   "status",       :default => "Unconfirmed"
    t.integer  "level_id"
    t.string   "card_type"
    t.integer  "card_last4"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "site"
    t.boolean  "confirmed",    :default => false
    t.string   "sponsor_type"
    t.string   "customer_id"
    t.boolean  "anonymous",    :default => false
  end

  create_table "project_updates", :force => true do |t|
    t.integer  "project_id"
    t.string   "title"
    t.text     "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "projects", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "location"
    t.string   "duration"
    t.string   "goal"
    t.string   "category"
    t.integer  "user_id"
    t.integer  "deleted"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "neighborhood"
    t.integer  "live"
    t.text     "short_description"
    t.string   "bitly"
    t.string   "project_token"
    t.string   "status"
    t.string   "website"
    t.string   "facebook_page"
    t.string   "twitter_handle"
    t.string   "organization"
    t.string   "large_image"
    t.text     "story"
    t.text     "about"
    t.string   "approval_date"
    t.string   "project_title"
    t.integer  "ready_for_approval"
    t.string   "seed_image"
    t.string   "cultivation_image"
    t.string   "organization_type"
    t.string   "organization_classification"
    t.string   "publishable_key"
    t.string   "seed_video"
    t.string   "cultivation_video"
    t.string   "seed_mime_type",              :default => "image"
    t.string   "cultivation_mime_type",       :default => "image"
    t.boolean  "perk_permission"
    t.datetime "campaign_deadline"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "sponsor_permission",          :default => true
    t.string   "step"
  end

  create_table "promotion_types", :force => true do |t|
    t.string   "name"
    t.string   "display_name"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "promotions", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at",                                                         :null => false
    t.datetime "updated_at",                                                         :null => false
    t.integer  "promotion_type_id"
    t.decimal  "amount",            :precision => 10, :scale => 2
    t.datetime "used_at"
    t.boolean  "reusable",                                         :default => true
  end

  create_table "reminder_emails", :force => true do |t|
    t.string   "email"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
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
    t.float    "cost",                 :default => 0.0
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

  create_table "subscriptions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "filter_type_id"
    t.integer  "months_between_deliveries"
    t.string   "stripe_customer_token"
    t.string   "street"
    t.string   "street2"
    t.string   "city"
    t.string   "state"
    t.string   "zipcode"
    t.datetime "created_at",                                                                   :null => false
    t.datetime "updated_at",                                                                   :null => false
    t.boolean  "confirmed",                                                 :default => false
    t.string   "address_state"
    t.string   "promo_code"
    t.float    "subtotal"
    t.float    "shipping_total"
    t.float    "promotion_total"
    t.integer  "promotion_id"
    t.integer  "last_fulfillment_id"
    t.string   "name"
    t.integer  "months_until_active"
    t.datetime "service_start_date"
    t.datetime "confirmed_at"
    t.text     "source"
    t.text     "notes"
    t.boolean  "active",                                                    :default => true
    t.decimal  "promotion_amount_remaining", :precision => 10, :scale => 2
    t.integer  "promotion_type_id"
    t.string   "email"
    t.string   "password_digest"
  end

  add_index "subscriptions", ["user_id"], :name => "index_subscriptions_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "password_digest"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
    t.string   "access_token"
  end

  add_index "users", ["email"], :name => "index_users_on_email"

end
