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

ActiveRecord::Schema.define(:version => 20140123173837) do

  create_table "accounts", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "badges_sashes", :force => true do |t|
    t.integer  "badge_id"
    t.integer  "sash_id"
    t.boolean  "notified_user", :default => false
    t.datetime "created_at"
  end

  add_index "badges_sashes", ["badge_id", "sash_id"], :name => "index_badges_sashes_on_badge_id_and_sash_id"
  add_index "badges_sashes", ["badge_id"], :name => "index_badges_sashes_on_badge_id"
  add_index "badges_sashes", ["sash_id"], :name => "index_badges_sashes_on_sash_id"

  create_table "comments", :force => true do |t|
    t.text    "body"
    t.integer "post_id"
    t.integer "user_id"
  end

  add_index "comments", ["post_id"], :name => "index_comments_on_post_id"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "contacts", :force => true do |t|
    t.string   "email"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "contacts", ["user_id"], :name => "index_contacts_on_user_id"

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

  add_index "documents", ["project_id"], :name => "index_documents_on_project_id"

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
    t.datetime "last_founded"
    t.boolean  "approved",       :default => false
  end

  add_index "donations", ["project_id"], :name => "index_donations_on_project_id"
  add_index "donations", ["user_id"], :name => "index_donations_on_user_id"

  create_table "features", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "galleries", :force => true do |t|
    t.string   "gallery_file_name"
    t.string   "gallery_content_type"
    t.datetime "gallery_updated_at"
    t.integer  "project_id"
    t.string   "gallery_type"
    t.string   "thumbnail_url"
  end

  add_index "galleries", ["project_id"], :name => "index_galleries_on_project_id"

  create_table "identities", :force => true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "token"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "identities", ["user_id"], :name => "index_identities_on_user_id"

  create_table "memberships", :force => true do |t|
    t.integer  "user_id"
    t.string   "kind"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "sponsor_id"
  end

  add_index "memberships", ["sponsor_id"], :name => "index_memberships_on_sponsor_id"
  add_index "memberships", ["user_id"], :name => "index_memberships_on_user_id"

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

  add_index "merit_actions", ["user_id"], :name => "index_merit_actions_on_user_id"

  create_table "merit_activity_logs", :force => true do |t|
    t.integer  "action_id"
    t.string   "related_change_type"
    t.integer  "related_change_id"
    t.string   "description"
    t.datetime "created_at"
  end

  add_index "merit_activity_logs", ["related_change_id"], :name => "index_merit_activity_logs_on_related_change_id"
  add_index "merit_activity_logs", ["related_change_type"], :name => "index_merit_activity_logs_on_related_change_type"

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

  add_index "merit_scores", ["sash_id"], :name => "index_merit_scores_on_sash_id"

  create_table "messages", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
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

  add_index "milestoneemails", ["project_id"], :name => "index_milestoneemails_on_project_id"

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

  add_index "perks", ["project_id"], :name => "index_perks_on_project_id"

  create_table "plan_features", :force => true do |t|
    t.integer  "plan_id"
    t.integer  "feature_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "plan_features", ["feature_id"], :name => "index_plan_features_on_feature_id"
  add_index "plan_features", ["plan_id"], :name => "index_plan_features_on_plan_id"

  create_table "plans", :force => true do |t|
    t.integer  "membership_id"
    t.string   "stripe_plan_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.string   "name"
  end

  add_index "plans", ["membership_id"], :name => "index_subscriptions_on_membership_id"

  create_table "posts", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "title"
    t.text     "body"
    t.integer  "project_id"
    t.integer  "user_id"
  end

  add_index "posts", ["project_id"], :name => "index_posts_on_project_id"
  add_index "posts", ["user_id"], :name => "index_posts_on_user_id"

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
    t.boolean  "approved",     :default => false
  end

  add_index "project_sponsors", ["project_id"], :name => "index_project_sponsors_on_project_id"
  add_index "project_sponsors", ["sponsor_id"], :name => "index_project_sponsors_on_sponsor_id"
  add_index "project_sponsors", ["sponsor_type"], :name => "index_project_sponsors_on_sponsor_type"

  create_table "project_updates", :force => true do |t|
    t.integer  "project_id"
    t.string   "title"
    t.text     "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "project_updates", ["project_id"], :name => "index_project_updates_on_project_id"

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
    t.integer  "live",                        :default => 0
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
    t.boolean  "perk_permission",             :default => false
    t.datetime "campaign_deadline"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "sponsor_permission",          :default => true
    t.string   "step"
    t.boolean  "partial_funding",             :default => false
  end

  add_index "projects", ["user_id"], :name => "index_projects_on_user_id"

  create_table "questions", :force => true do |t|
    t.string   "subject"
    t.text     "body"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "project_id"
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

  add_index "services", ["user_id"], :name => "index_services_on_user_id"

  create_table "sessions", :force => true do |t|
    t.string "session_id"
    t.text   "data"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"

  create_table "settings", :force => true do |t|
    t.string   "var",         :null => false
    t.text     "value"
    t.integer  "target_id",   :null => false
    t.string   "target_type", :null => false
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "settings", ["target_type", "target_id", "var"], :name => "index_settings_on_target_type_and_target_id_and_var", :unique => true

  create_table "sponsors", :force => true do |t|
    t.string  "payment_type"
    t.string  "name"
    t.string  "card_number"
    t.string  "cvc"
    t.string  "email"
    t.string  "phone"
    t.integer "month"
    t.integer "year_card"
    t.string  "token"
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

  add_index "sponsorship_benefits", ["project_id"], :name => "index_sponsorship_benefits_on_project_id"
  add_index "sponsorship_benefits", ["sponsorship_level_id"], :name => "index_sponsorship_benefits_on_sponsorship_level_id"

  create_table "sponsorship_levels", :force => true do |t|
    t.string   "name"
    t.float    "cost"
    t.text     "description"
    t.integer  "required"
    t.integer  "funding_goal"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "tax_reports", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "url"
    t.integer  "user_id"
    t.integer  "project_id"
  end

  add_index "tax_reports", ["project_id"], :name => "index_tax_reports_on_project_id"
  add_index "tax_reports", ["user_id"], :name => "index_tax_reports_on_user_id"

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
    t.integer  "uruut_point",            :default => 0
    t.string   "role",                   :default => ""
    t.integer  "account_id"
    t.string   "stripe_user_token"
    t.string   "stripe_card_token"
  end

  add_index "users", ["account_id"], :name => "index_users_on_account_id"
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["sash_id"], :name => "index_users_on_sash_id"

end
