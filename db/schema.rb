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

ActiveRecord::Schema.define(:version => 20141102001644) do

  create_table "abandon_logs", :force => true do |t|
    t.datetime "reopen"
    t.integer  "project_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "activities", :force => true do |t|
    t.integer  "trackable_id"
    t.string   "trackable_type"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "key"
    t.text     "parameters"
    t.integer  "recipient_id"
    t.string   "recipient_type"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.datetime "commented_at"
    t.datetime "deleted_at"
    t.boolean  "deleted",        :default => false
    t.boolean  "featured",       :default => false
    t.string   "realm"
    t.boolean  "draft"
    t.boolean  "test",           :default => false
  end

  add_index "activities", ["owner_id", "owner_type"], :name => "index_activities_on_owner_id_and_owner_type"
  add_index "activities", ["recipient_id", "recipient_type"], :name => "index_activities_on_recipient_id_and_recipient_type"
  add_index "activities", ["trackable_id", "trackable_type"], :name => "index_activities_on_trackable_id_and_trackable_type"

  create_table "amazon_recipients", :force => true do |t|
    t.string   "callerReference"
    t.string   "callerReferenceRefund"
    t.decimal  "maxFixedFee",                  :precision => 10, :scale => 2
    t.decimal  "maxVariableFee",               :precision => 10, :scale => 2
    t.string   "recipientPaysFee"
    t.datetime "validityExpiry"
    t.datetime "validityStart"
    t.integer  "user_id"
    t.string   "errorMessage"
    t.string   "Status"
    t.string   "tokenID"
    t.datetime "created_at",                                                  :null => false
    t.datetime "updated_at",                                                  :null => false
    t.string   "uuid"
    t.string   "VerificationComplete"
    t.string   "VerificationPending"
    t.string   "VerificationCompleteNoLimits"
  end

  create_table "amazon_recurrings", :force => true do |t|
    t.string   "addressName"
    t.string   "addressLine1"
    t.string   "addressLine2"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "zip"
    t.string   "phoneNumber"
    t.string   "callerReference"
    t.boolean  "collectShippingAddress"
    t.string   "currencyCode"
    t.boolean  "isRecipientCobranding"
    t.string   "paymentReason"
    t.string   "recipientToken"
    t.string   "recurringPeriod"
    t.string   "transactionAmount"
    t.datetime "validityExpiry"
    t.datetime "validityStart"
    t.string   "tokenID"
    t.string   "errorMessage"
    t.string   "warningCode"
    t.string   "warningMessage"
    t.string   "uuid"
    t.integer  "subscription_id"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
    t.string   "status"
  end

  create_table "archiveimages", :force => true do |t|
    t.integer  "archive_id"
    t.text     "url"
    t.string   "thumbnail"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "archives", :force => true do |t|
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "title"
    t.text     "content"
    t.integer  "project_id"
    t.integer  "majorpost_id"
    t.datetime "created_time"
    t.integer  "user_id"
  end

  create_table "artworks", :force => true do |t|
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.string   "artwork"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "majorpost_id"
    t.integer  "project_id"
    t.text     "content_temp"
    t.text     "tags_temp"
    t.integer  "archive_id"
    t.string   "direct_upload_url",                     :null => false
    t.boolean  "processed",          :default => false, :null => false
    t.integer  "user_id",                               :null => false
  end

  add_index "artworks", ["processed"], :name => "index_artworks_on_processed"
  add_index "artworks", ["user_id"], :name => "index_artworks_on_user_id"

  create_table "assigned_projects", :force => true do |t|
    t.integer  "project_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "audios", :force => true do |t|
    t.string   "audio"
    t.integer  "majorpost_id"
    t.integer  "project_id"
    t.text     "content_temp"
    t.text     "tags_temp"
    t.integer  "archive_id"
    t.string   "direct_upload_url",                     :null => false
    t.boolean  "processed",          :default => false, :null => false
    t.integer  "user_id",                               :null => false
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.string   "soundcloud"
    t.string   "audio_file_name"
    t.string   "audio_content_type"
    t.integer  "audio_file_size"
    t.datetime "audio_updated_at"
    t.string   "soundcloud_image"
    t.integer  "default_image",      :default => 0
  end

  create_table "beta_users", :force => true do |t|
    t.string   "fullname"
    t.string   "username"
    t.string   "email"
    t.boolean  "creator"
    t.text     "website"
    t.string   "realm"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "approved"
    t.boolean  "ignore"
  end

  create_table "bifrosts", :force => true do |t|
    t.integer  "project_id"
    t.integer  "majorpost_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blacklists", :force => true do |t|
    t.integer  "blacklister_id"
    t.integer  "blacklisted_id"
    t.boolean  "message",        :default => false
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  create_table "blogposts", :force => true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.string   "slug"
    t.string   "category"
    t.text     "content"
    t.text     "excerpt"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "deleted",    :default => false
    t.boolean  "featured"
    t.boolean  "published"
    t.datetime "deleted_at"
  end

  create_table "commentimages", :force => true do |t|
    t.integer  "comment_id"
    t.text     "url"
    t.string   "thumbnail"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.integer  "project_comment_id"
  end

  create_table "comments", :force => true do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "majorpost_id"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.integer  "project_id"
    t.text     "excerpt"
    t.datetime "deleted_at"
    t.boolean  "deleted",      :default => false
  end

  add_index "comments", ["user_id", "majorpost_id", "created_at"], :name => "index_comments_on_user_id_and_majorpost_id_and_created_at"

  create_table "connections", :force => true do |t|
    t.integer  "bifrost_id"
    t.text     "url"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.boolean  "internal",   :default => true
  end

  create_table "created_projects", :force => true do |t|
    t.integer  "project_id"
    t.integer  "creator_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "deviantarts", :force => true do |t|
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
    t.integer  "user_id"
    t.string   "uid"
    t.string   "nickname"
    t.string   "image"
    t.string   "oauth_token"
    t.string   "oauth_token_expires_at"
    t.string   "link"
  end

  create_table "facebooks", :force => true do |t|
    t.string   "uid"
    t.string   "name"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "link"
    t.string   "username"
    t.string   "gender"
    t.string   "locale"
    t.integer  "age_min"
    t.integer  "age_max"
    t.integer  "user_id"
    t.string   "oauth_token"
    t.string   "oauth_expires_at"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.string   "user_birthday"
    t.string   "email"
    t.string   "image"
  end

  create_table "friendly_id_slugs", :force => true do |t|
    t.string   "slug",                         :null => false
    t.integer  "sluggable_id",                 :null => false
    t.string   "sluggable_type", :limit => 40
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type"], :name => "index_friendly_id_slugs_on_slug_and_sluggable_type", :unique => true
  add_index "friendly_id_slugs", ["sluggable_id"], :name => "index_friendly_id_slugs_on_sluggable_id"
  add_index "friendly_id_slugs", ["sluggable_type"], :name => "index_friendly_id_slugs_on_sluggable_type"

  create_table "githubs", :force => true do |t|
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "user_id"
    t.string   "uid"
    t.string   "email"
    t.string   "image"
    t.string   "link"
    t.string   "oauth_token"
    t.string   "username"
    t.string   "name"
    t.string   "hireable"
    t.string   "public_repos"
  end

  create_table "ibifrosts", :force => true do |t|
    t.integer  "project_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "icons", :force => true do |t|
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "project_id"
    t.text     "content_temp"
    t.text     "tags_temp"
    t.integer  "archive_id"
    t.string   "direct_upload_url",                     :null => false
    t.boolean  "processed",          :default => false, :null => false
    t.integer  "user_id",                               :null => false
  end

  add_index "icons", ["processed"], :name => "index_icons_on_processed"
  add_index "icons", ["user_id"], :name => "index_icons_on_user_id"

  create_table "inviteds", :force => true do |t|
    t.integer  "project_id"
    t.integer  "user_id"
    t.string   "username"
    t.boolean  "accept",      :default => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.integer  "ibifrost_id"
  end

  create_table "liked_activities", :force => true do |t|
    t.integer  "user_id"
    t.integer  "activity_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "type"
  end

  create_table "liked_comments", :force => true do |t|
    t.integer  "comment_id"
    t.integer  "user_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.integer  "project_comment_id"
  end

  create_table "liked_majorposts", :force => true do |t|
    t.integer  "majorpost_id"
    t.integer  "user_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "liked_projects", :force => true do |t|
    t.integer  "project_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "m_e_inspirations", :force => true do |t|
    t.integer  "inspired_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "url"
    t.string   "title"
  end

  create_table "m_m_inspirations", :force => true do |t|
    t.integer  "inspirer_id"
    t.integer  "inspired_id"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
    t.string   "inspired_majorpost_title"
    t.string   "inspirer_majorpost_title"
    t.string   "inspirer_majorpost_username"
  end

  add_index "m_m_inspirations", ["inspired_id"], :name => "index_m_m_inspirations_on_inspired_id"
  add_index "m_m_inspirations", ["inspirer_id", "inspired_id"], :name => "index_m_m_inspirations_on_inspirer_id_and_inspired_id", :unique => true
  add_index "m_m_inspirations", ["inspirer_id"], :name => "index_m_m_inspirations_on_inspirer_id"

  create_table "m_p_inspirations", :force => true do |t|
    t.integer  "inspirer_id"
    t.integer  "inspired_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "project_title"
    t.string   "project_creator_username"
  end

  create_table "m_u_inspirations", :force => true do |t|
    t.integer  "inspirer_id"
    t.integer  "inspired_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "user_username"
  end

  create_table "mailboxer_conversation_opt_outs", :force => true do |t|
    t.integer "unsubscriber_id"
    t.string  "unsubscriber_type"
    t.integer "conversation_id"
  end

  add_index "mailboxer_conversation_opt_outs", ["conversation_id"], :name => "mb_opt_outs_on_conversations_id"

  create_table "mailboxer_conversations", :force => true do |t|
    t.string   "subject",    :default => ""
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "blocked",    :default => false
    t.boolean  "not_accept", :default => false
  end

  create_table "mailboxer_notifications", :force => true do |t|
    t.string   "type"
    t.text     "body"
    t.string   "subject",              :default => ""
    t.integer  "sender_id"
    t.string   "sender_type"
    t.integer  "conversation_id"
    t.boolean  "draft",                :default => false
    t.string   "notification_code"
    t.integer  "notified_object_id"
    t.string   "notified_object_type"
    t.string   "attachment"
    t.datetime "updated_at",                              :null => false
    t.datetime "created_at",                              :null => false
    t.boolean  "global",               :default => false
    t.datetime "expires"
  end

  add_index "mailboxer_notifications", ["conversation_id"], :name => "index_mailboxer_notifications_on_conversation_id"

  create_table "mailboxer_receipts", :force => true do |t|
    t.integer  "receiver_id"
    t.string   "receiver_type"
    t.integer  "notification_id",                                  :null => false
    t.boolean  "is_read",                       :default => false
    t.boolean  "trashed",                       :default => false
    t.boolean  "deleted",                       :default => false
    t.string   "mailbox_type",    :limit => 25
    t.datetime "created_at",                                       :null => false
    t.datetime "updated_at",                                       :null => false
    t.boolean  "blocked",                       :default => false
    t.boolean  "not_accept",                    :default => false
  end

  add_index "mailboxer_receipts", ["notification_id"], :name => "index_mailboxer_receipts_on_notification_id"

  create_table "majorposts", :force => true do |t|
    t.text     "content"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "project_id"
    t.string   "title"
    t.string   "slug"
    t.string   "artwork_id"
    t.boolean  "published"
    t.text     "perlink"
    t.integer  "video_id"
    t.text     "excerpt"
    t.string   "edit_permission", :default => "free"
    t.boolean  "archived",        :default => false
    t.datetime "commented_at"
    t.datetime "deleted_at"
    t.boolean  "deleted",         :default => false
    t.boolean  "featured"
    t.string   "uuid"
    t.boolean  "test",            :default => false
    t.datetime "published_at"
    t.boolean  "early_access",    :default => false
    t.integer  "audio_id"
  end

  create_table "messages", :force => true do |t|
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "title"
    t.text     "content"
    t.integer  "receiver_id"
    t.integer  "sender_id"
    t.integer  "conversation_id"
  end

  create_table "p_e_inspirations", :force => true do |t|
    t.integer  "inspired_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "url"
    t.string   "title"
  end

  create_table "p_m_inspirations", :force => true do |t|
    t.integer  "inspirer_id"
    t.integer  "inspired_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "project_title"
    t.string   "majorpost_title"
    t.string   "majorpost_username"
  end

  create_table "p_p_inspirations", :force => true do |t|
    t.integer  "inspirer_id"
    t.integer  "inspired_id"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.string   "inspirer_project_title"
    t.string   "inspired_project_title"
    t.string   "inspirer_project_username"
  end

  add_index "p_p_inspirations", ["inspired_id"], :name => "index_p_p_inspirations_on_inspired_id"
  add_index "p_p_inspirations", ["inspirer_id", "inspired_id"], :name => "index_p_p_inspirations_on_inspirer_id_and_inspired_id", :unique => true
  add_index "p_p_inspirations", ["inspirer_id"], :name => "index_p_p_inspirations_on_inspirer_id"

  create_table "p_u_inspirations", :force => true do |t|
    t.integer  "inspirer_id"
    t.integer  "inspired_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "user_username"
  end

  add_index "p_u_inspirations", ["inspired_id"], :name => "index_p_u_inspirations_on_inspired_id"
  add_index "p_u_inspirations", ["inspirer_id", "inspired_id"], :name => "index_p_u_inspirations_on_inspirer_id_and_inspired_id", :unique => true
  add_index "p_u_inspirations", ["inspirer_id"], :name => "index_p_u_inspirations_on_inspirer_id"

  create_table "payments", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "postimages", :force => true do |t|
    t.integer  "majorpost_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.text     "url"
    t.string   "thumbnail"
  end

  create_table "project_comments", :force => true do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "project_id"
    t.text     "excerpt"
    t.datetime "deleted_at"
    t.boolean  "deleted",    :default => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "project_suggestions", :force => true do |t|
    t.string   "term"
    t.integer  "popularity"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "projectimages", :force => true do |t|
    t.integer  "project_id"
    t.text     "url"
    t.string   "thumbnail"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "projects", :force => true do |t|
    t.string   "title"
    t.string   "tagline"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "complete"
    t.text     "about"
    t.integer  "creator_id"
    t.string   "slug"
    t.boolean  "published"
    t.integer  "artwork_id"
    t.text     "perlink"
    t.string   "video_id"
    t.integer  "icon_id"
    t.integer  "goal"
    t.string   "source_code"
    t.string   "source_code_type"
    t.string   "source_code_title"
    t.text     "excerpt"
    t.string   "edit_permission"
    t.boolean  "flag"
    t.datetime "completion_time"
    t.string   "realm"
    t.datetime "commented_at"
    t.boolean  "abandoned",         :default => false
    t.datetime "deleted_at"
    t.boolean  "deleted",           :default => false
    t.boolean  "featured",          :default => false
    t.string   "uuid"
    t.boolean  "test",              :default => false
    t.datetime "published_at"
    t.boolean  "early_access",      :default => false
    t.integer  "audio_id"
  end

  create_table "quotes", :force => true do |t|
    t.text     "content"
    t.string   "by"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "redactor_assets", :force => true do |t|
    t.integer  "user_id"
    t.string   "data_file_name",                  :null => false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    :limit => 30
    t.string   "type",              :limit => 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_index "redactor_assets", ["assetable_type", "assetable_id"], :name => "idx_redactor_assetable"
  add_index "redactor_assets", ["assetable_type", "type", "assetable_id"], :name => "idx_redactor_assetable_type"

  create_table "subscription_records", :force => true do |t|
    t.integer  "subscriber_id"
    t.integer  "subscribed_id"
    t.decimal  "accumulated_receive",  :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "accumulated_amazon",   :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "accumulated_ratafire", :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "accumulated_total",    :precision => 10, :scale => 2, :default => 0.0
    t.datetime "created_at",                                                             :null => false
    t.datetime "updated_at",                                                             :null => false
    t.boolean  "past",                                                :default => false
    t.boolean  "accumulated",                                         :default => false
    t.decimal  "duration",             :precision => 32, :scale => 6
    t.boolean  "supporter_switch",                                    :default => false
    t.boolean  "past_support",                                        :default => false
    t.boolean  "duration_support",                                    :default => false
    t.integer  "counter",                                             :default => 0
  end

  create_table "subscriptions", :force => true do |t|
    t.integer  "subscriber_id"
    t.integer  "subscribed_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "amount",                   :precision => 10, :scale => 2
    t.datetime "deleted_at"
    t.decimal  "accumulated_receive",      :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "accumulated_amazon",       :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "accumulated_ratafire",     :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "accumulated_total",        :precision => 10, :scale => 2, :default => 0.0
    t.boolean  "amazon_valid",                                            :default => false
    t.integer  "subscription_record_id"
    t.integer  "project_id"
    t.integer  "deleted_reason"
    t.datetime "activated_at"
    t.boolean  "activated",                                               :default => false
    t.boolean  "deleted",                                                 :default => false
    t.string   "uuid"
    t.boolean  "supporter_switch",                                        :default => false
    t.datetime "this_billing_date"
    t.datetime "next_billing_date"
    t.boolean  "first_payment",                                           :default => false
    t.datetime "first_payment_created_at"
    t.integer  "counter",                                                 :default => 0
    t.boolean  "next_transaction_queued",                                 :default => false
    t.integer  "retry",                                                   :default => 0
  end

  create_table "tag_relationships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "tag_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       :limit => 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "tags_suggestions", :force => true do |t|
    t.string   "term"
    t.integer  "popularity"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "transactions", :force => true do |t|
    t.datetime "created_at",                                                                  :null => false
    t.decimal  "receive",                 :precision => 10, :scale => 2
    t.decimal  "amazon",                  :precision => 10, :scale => 2
    t.integer  "ratafire"
    t.decimal  "total",                   :precision => 10, :scale => 2
    t.boolean  "sucess"
    t.integer  "subscriber_id"
    t.integer  "subscribed_id"
    t.datetime "updated_at",                                                                  :null => false
    t.string   "CallerReference"
    t.string   "ChargeFeeTo"
    t.string   "RecipientTokenId"
    t.string   "SenderTokenId"
    t.string   "TransactionId"
    t.string   "StatusCode"
    t.text     "StatusMessage"
    t.string   "status",                                                 :default => "Error"
    t.integer  "subscription_record_id"
    t.string   "amount"
    t.string   "uuid"
    t.decimal  "ratafire_fee",            :precision => 10, :scale => 2
    t.string   "error"
    t.boolean  "supporter_switch",                                       :default => false
    t.integer  "subscription_id"
    t.datetime "next_transaction"
    t.boolean  "next_transaction_status",                                :default => false
    t.integer  "counter",                                                :default => 0
    t.integer  "retry",                                                  :default => 0
  end

  create_table "twitters", :force => true do |t|
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "user_id"
    t.string   "uid"
    t.string   "name"
    t.string   "image"
    t.string   "location"
    t.string   "description"
    t.string   "link"
    t.string   "oauth_token"
    t.string   "oauth_secret"
    t.string   "lang"
    t.integer  "followers_count"
    t.string   "entities"
    t.string   "nickname"
  end

  create_table "updates", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "user_suggestions", :force => true do |t|
    t.string   "term"
    t.integer  "popularity"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "tagline",                                                  :default => "Sits down at the fire of Ratatoskr"
    t.string   "fullname"
    t.string   "username"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin"
    t.text     "website"
    t.text     "bio"
    t.string   "profilelarge_file_name"
    t.string   "profilelarge_content_type"
    t.integer  "profilelarge_file_size"
    t.datetime "profilelarge_updated_at"
    t.string   "profilemedium_file_name"
    t.string   "profilemedium_content_type"
    t.integer  "profilemedium_file_size"
    t.datetime "profilemedium_updated_at"
    t.string   "profilephoto_file_name"
    t.string   "profilephoto_content_type"
    t.integer  "profilephoto_file_size"
    t.datetime "profilephoto_updated_at"
    t.integer  "goals_subscribers",                                        :default => 256
    t.integer  "goals_monthly",                                            :default => 7730
    t.integer  "goals_project",                                            :default => 5
    t.string   "encrypted_password"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count"
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "provider"
    t.string   "uid"
    t.decimal  "subscription_amount",        :precision => 8, :scale => 2, :default => 0.0
    t.text     "why"
    t.boolean  "subscription_status",                                      :default => false
    t.text     "plan"
    t.boolean  "subscription_switch",                                      :default => false
    t.boolean  "amazon_authorized",                                        :default => false
    t.string   "subscribed_permission"
    t.string   "subscriber_permission"
    t.boolean  "disabled",                                                 :default => false
    t.datetime "deactivated_at"
    t.datetime "goals_updated_at"
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.integer  "invitations_count",                                        :default => 0
    t.decimal  "subscribing_amount",         :precision => 8, :scale => 2, :default => 0.0
    t.integer  "supporter_slot",                                           :default => 5
    t.boolean  "amount_display_switch",                                    :default => false
    t.boolean  "accept_message",                                           :default => true
    t.string   "uuid"
    t.string   "location"
    t.string   "bio_html"
  end

  add_index "users", ["deactivated_at"], :name => "index_users_on_deactivated_at"
  add_index "users", ["invitation_token"], :name => "index_users_on_invitation_token", :unique => true
  add_index "users", ["invitations_count"], :name => "index_users_on_invitations_count"
  add_index "users", ["invited_by_id"], :name => "index_users_on_invited_by_id"

  create_table "videos", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "majorpost_id"
    t.text     "external"
    t.boolean  "youtube_vimeo"
    t.integer  "project_id"
    t.string   "thumbnail_file_name"
    t.string   "thumbnail_content_type"
    t.integer  "thumbnail_file_size"
    t.datetime "thumbnail_updated_at"
    t.string   "video_file_name"
    t.string   "video_content_type"
    t.integer  "video_file_size"
    t.datetime "video_updated_at"
    t.string   "job_id"
    t.string   "encoded_state",          :default => "unencoded"
    t.string   "output_url"
    t.integer  "duration_in_ms"
    t.string   "aspect_ratio"
    t.text     "content_temp"
    t.text     "tags_temp"
    t.integer  "archive_id"
    t.string   "thumbnail"
    t.string   "direct_upload_url",                               :null => false
    t.boolean  "processed",              :default => false,       :null => false
    t.integer  "user_id",                                         :null => false
    t.string   "output_url_mp4"
  end

  add_index "videos", ["processed"], :name => "index_videos_on_processed"
  add_index "videos", ["user_id"], :name => "index_videos_on_user_id"

  create_table "vimeos", :force => true do |t|
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "user_id"
    t.string   "oauth_token"
    t.string   "oauth_secret"
    t.string   "link"
    t.string   "nickname"
    t.string   "uid"
    t.string   "name"
    t.text     "description"
    t.string   "image"
  end

  add_foreign_key "mailboxer_conversation_opt_outs", "mailboxer_conversations", name: "mb_opt_outs_on_conversations_id", column: "conversation_id"

  add_foreign_key "mailboxer_notifications", "mailboxer_conversations", name: "notifications_on_conversation_id", column: "conversation_id"

  add_foreign_key "mailboxer_receipts", "mailboxer_notifications", name: "receipts_on_notification_id", column: "notification_id"

end
