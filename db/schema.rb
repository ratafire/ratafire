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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160209035543) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "abandon_logs", id: :bigserial, force: :cascade do |t|
    t.datetime "reopen"
    t.integer  "project_id", limit: 8
    t.integer  "user_id",    limit: 8
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "activities", id: :bigserial, force: :cascade do |t|
    t.integer  "trackable_id",   limit: 8
    t.text     "trackable_type"
    t.integer  "owner_id",       limit: 8
    t.text     "owner_type"
    t.text     "key"
    t.text     "parameters"
    t.integer  "recipient_id",   limit: 8
    t.text     "recipient_type"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.datetime "commented_at"
    t.datetime "deleted_at"
    t.boolean  "deleted",                  default: false
    t.boolean  "featured",                 default: false
    t.text     "realm"
    t.boolean  "test",                     default: false
    t.boolean  "featured_home",            default: false
    t.text     "sub_realm"
    t.text     "status"
    t.boolean  "abandoned"
    t.boolean  "listed"
    t.boolean  "reviewed"
    t.boolean  "published",                default: true
  end

  add_index "activities", ["owner_id", "owner_type"], name: "idx_16401_index_activities_on_owner_id_and_owner_type", using: :btree
  add_index "activities", ["recipient_id", "recipient_type"], name: "idx_16401_index_activities_on_recipient_id_and_recipient_type", using: :btree
  add_index "activities", ["trackable_id", "trackable_type"], name: "idx_16401_index_activities_on_trackable_id_and_trackable_type", using: :btree

  create_table "amazon_recipients", id: :bigserial, force: :cascade do |t|
    t.text     "callerreference"
    t.text     "callerreferencerefund"
    t.decimal  "maxfixedfee",                            precision: 10, scale: 2
    t.decimal  "maxvariablefee",                         precision: 10, scale: 2
    t.text     "recipientpaysfee"
    t.datetime "validityexpiry"
    t.datetime "validitystart"
    t.integer  "user_id",                      limit: 8
    t.text     "errormessage"
    t.text     "status"
    t.text     "tokenid"
    t.datetime "created_at",                                                      null: false
    t.datetime "updated_at",                                                      null: false
    t.text     "uuid"
    t.text     "verificationcomplete"
    t.text     "verificationpending"
    t.text     "verificationcompletenolimits"
  end

  create_table "amazon_recurrings", id: :bigserial, force: :cascade do |t|
    t.text     "addressname"
    t.text     "addressline1"
    t.text     "addressline2"
    t.text     "city"
    t.text     "state"
    t.text     "country"
    t.text     "zip"
    t.text     "phonenumber"
    t.text     "callerreference"
    t.boolean  "collectshippingaddress"
    t.text     "currencycode"
    t.boolean  "isrecipientcobranding"
    t.text     "paymentreason"
    t.text     "recipienttoken"
    t.text     "recurringperiod"
    t.text     "transactionamount"
    t.datetime "validityexpiry"
    t.datetime "validitystart"
    t.text     "tokenid"
    t.text     "errormessage"
    t.text     "warningcode"
    t.text     "warningmessage"
    t.text     "uuid"
    t.integer  "subscription_id",        limit: 8
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.text     "status"
  end

  create_table "archiveimages", id: :bigserial, force: :cascade do |t|
    t.integer  "archive_id", limit: 8
    t.text     "url"
    t.text     "thumbnail"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "archives", id: :bigserial, force: :cascade do |t|
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.text     "title"
    t.text     "content"
    t.integer  "project_id",   limit: 8
    t.integer  "majorpost_id", limit: 8
    t.datetime "created_time"
    t.integer  "user_id",      limit: 8
    t.integer  "pdf_id",       limit: 8
    t.integer  "audio_id",     limit: 8
  end

  create_table "artworks", id: :bigserial, force: :cascade do |t|
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.text     "artwork"
    t.text     "image_file_name"
    t.text     "image_content_type"
    t.integer  "image_file_size",    limit: 8
    t.datetime "image_updated_at"
    t.integer  "majorpost_id",       limit: 8
    t.integer  "project_id",         limit: 8
    t.text     "content_temp"
    t.text     "tags_temp"
    t.integer  "archive_id",         limit: 8
    t.string   "direct_upload_url"
    t.boolean  "processed",                    default: false, null: false
    t.integer  "user_id",            limit: 8,                 null: false
    t.boolean  "skip_everafter",               default: false
    t.string   "uuid"
    t.string   "majorpost_uuid"
  end

  add_index "artworks", ["processed"], name: "idx_16450_index_artworks_on_processed", using: :btree
  add_index "artworks", ["user_id"], name: "idx_16450_index_artworks_on_user_id", using: :btree

  create_table "assigned_discussion_threads", id: :bigserial, force: :cascade do |t|
    t.integer  "assigned_discussion_id", limit: 8
    t.integer  "user_id",                limit: 8
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  create_table "assigned_discussions", id: :bigserial, force: :cascade do |t|
    t.integer  "discussion_id", limit: 8
    t.integer  "user_id",       limit: 8
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "assigned_projects", id: :bigserial, force: :cascade do |t|
    t.integer  "project_id", limit: 8
    t.integer  "user_id",    limit: 8
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "audio_images", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "majorpost_id"
    t.string   "audio_id"
    t.boolean  "deleted"
    t.datetime "deleted_at"
    t.string   "direct_upload_url"
    t.string   "uuid"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "audio_uuid"
    t.string   "majorpost_uuid"
    t.boolean  "skip_everafter"
  end

  create_table "audios", id: :bigserial, force: :cascade do |t|
    t.text     "audio"
    t.integer  "majorpost_id",            limit: 8
    t.integer  "project_id",              limit: 8
    t.text     "content_temp"
    t.text     "tags_temp"
    t.integer  "archive_id",              limit: 8
    t.string   "direct_upload_url"
    t.boolean  "processed",                         default: false, null: false
    t.integer  "user_id",                 limit: 8,                 null: false
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.text     "soundcloud"
    t.text     "audio_file_name"
    t.text     "audio_content_type"
    t.integer  "audio_file_size",         limit: 8
    t.datetime "audio_updated_at"
    t.text     "soundcloud_image"
    t.integer  "default_image",           limit: 8, default: 0
    t.boolean  "skip_everafter",                    default: false
    t.string   "majorpost_uuid"
    t.string   "uuid"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "composer"
    t.string   "artist"
    t.text     "title"
    t.string   "direct_image_upload_url"
    t.text     "description"
    t.string   "genre"
  end

  create_table "beta_users", id: :bigserial, force: :cascade do |t|
    t.text     "fullname"
    t.text     "username"
    t.text     "email"
    t.boolean  "creator"
    t.text     "website"
    t.text     "realm"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text     "approved"
    t.boolean  "ignore"
  end

  create_table "bifrosts", id: :bigserial, force: :cascade do |t|
    t.integer  "project_id",   limit: 8
    t.integer  "majorpost_id", limit: 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "billing_agreements", id: :bigserial, force: :cascade do |t|
    t.integer  "user_id",              limit: 8
    t.text     "billing_agreement_id"
    t.text     "status"
    t.boolean  "deleted"
    t.datetime "deleted_at"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.text     "uuid"
  end

  create_table "billing_artists", id: :bigserial, force: :cascade do |t|
    t.integer  "user_id",                 limit: 8
    t.integer  "count",                   limit: 8
    t.decimal  "accumulated_receive",               precision: 10, scale: 2, default: 0.0
    t.decimal  "accumulated_payment_fee",           precision: 10, scale: 2, default: 0.0
    t.decimal  "accumulated_ratafire",              precision: 10, scale: 2, default: 0.0
    t.decimal  "accumulated_total",                 precision: 10, scale: 2, default: 0.0
    t.boolean  "deleted"
    t.datetime "deleted_at"
    t.datetime "this_billing_date"
    t.datetime "next_billing_date"
    t.datetime "prev_billing_date"
    t.decimal  "this_amount",                       precision: 10, scale: 2, default: 0.0
    t.decimal  "next_amount",                       precision: 10, scale: 2, default: 0.0
    t.integer  "retry",                   limit: 8
    t.text     "uuid"
    t.boolean  "activated"
    t.datetime "activated_at"
    t.datetime "created_at",                                                               null: false
    t.datetime "updated_at",                                                               null: false
  end

  create_table "billing_subscriptions", id: :bigserial, force: :cascade do |t|
    t.integer  "user_id",                 limit: 8
    t.integer  "count",                   limit: 8
    t.decimal  "accumulated_receive",               precision: 10, scale: 2, default: 0.0
    t.decimal  "accumulated_payment_fee",           precision: 10, scale: 2, default: 0.0
    t.decimal  "accumulated_ratafire",              precision: 10, scale: 2, default: 0.0
    t.decimal  "accumulated_total",                 precision: 10, scale: 2, default: 0.0
    t.boolean  "deleted"
    t.datetime "deleted_at"
    t.datetime "this_billing_date"
    t.datetime "next_billing_date"
    t.datetime "prev_billing_date"
    t.decimal  "this_amount",                       precision: 10, scale: 2, default: 0.0
    t.decimal  "next_amount",                       precision: 10, scale: 2, default: 0.0
    t.integer  "retry",                   limit: 8
    t.text     "uuid"
    t.boolean  "activated"
    t.datetime "activated_at"
    t.datetime "created_at",                                                               null: false
    t.datetime "updated_at",                                                               null: false
  end

  create_table "blacklists", id: :bigserial, force: :cascade do |t|
    t.integer  "blacklister_id", limit: 8
    t.integer  "blacklisted_id", limit: 8
    t.boolean  "message",                  default: false
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  create_table "blogposts", id: :bigserial, force: :cascade do |t|
    t.integer  "user_id",    limit: 8
    t.text     "title"
    t.text     "slug"
    t.text     "category"
    t.text     "content"
    t.text     "excerpt"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.boolean  "deleted",              default: false
    t.boolean  "featured"
    t.boolean  "published"
    t.datetime "deleted_at"
  end

  create_table "cards", id: :bigserial, force: :cascade do |t|
    t.integer  "user_id",             limit: 8
    t.text     "customer_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.text     "last4"
    t.text     "brand"
    t.text     "funding"
    t.text     "exp_month"
    t.text     "exp_year"
    t.text     "fingerprint"
    t.text     "country"
    t.text     "name"
    t.text     "address_line1"
    t.text     "address_line2"
    t.text     "address_city"
    t.text     "address_state"
    t.text     "address_zip"
    t.text     "address_country"
    t.text     "object"
    t.text     "cvc_check"
    t.text     "address_line1_check"
    t.text     "address_zip_check"
    t.text     "dynamic_last4"
    t.datetime "deleted_at"
    t.boolean  "deleted"
    t.text     "customer_stripe_id"
    t.text     "card_stripe_id"
    t.text     "cardno"
    t.text     "cardcvc"
    t.text     "uuid"
  end

  create_table "collectibles", id: :bigserial, force: :cascade do |t|
    t.integer  "project_id",      limit: 8
    t.integer  "user_id",         limit: 8
    t.integer  "facebookpage_id", limit: 8
    t.integer  "level",           limit: 8
    t.text     "content"
    t.boolean  "deleted"
    t.datetime "deleted_at"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "commentimages", id: :bigserial, force: :cascade do |t|
    t.integer  "comment_id",         limit: 8
    t.text     "url"
    t.text     "thumbnail"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "project_comment_id", limit: 8
  end

  create_table "comments", id: :bigserial, force: :cascade do |t|
    t.text     "content"
    t.integer  "user_id",      limit: 8
    t.integer  "majorpost_id", limit: 8
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.integer  "project_id",   limit: 8
    t.text     "excerpt"
    t.datetime "deleted_at"
    t.boolean  "deleted",                default: false
  end

  add_index "comments", ["user_id", "majorpost_id", "created_at"], name: "idx_16589_index_comments_on_user_id_and_majorpost_id_and_create", using: :btree

  create_table "connections", id: :bigserial, force: :cascade do |t|
    t.integer  "bifrost_id", limit: 8
    t.text     "url"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.boolean  "internal",             default: true
  end

  create_table "created_projects", id: :bigserial, force: :cascade do |t|
    t.integer  "project_id", limit: 8
    t.integer  "creator_id", limit: 8
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "customers", id: :bigserial, force: :cascade do |t|
    t.text     "customer_id"
    t.text     "object"
    t.boolean  "livemode"
    t.integer  "account_balance", limit: 8
    t.text     "currency"
    t.text     "default_source"
    t.boolean  "delinquent"
    t.text     "description"
    t.text     "email"
    t.integer  "user_id",         limit: 8
    t.datetime "deleted_at"
    t.boolean  "deleted"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.text     "uuid"
  end

  create_table "deviantarts", id: :bigserial, force: :cascade do |t|
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "user_id",                limit: 8
    t.text     "uid"
    t.text     "nickname"
    t.text     "image"
    t.text     "oauth_token"
    t.text     "oauth_token_expires_at"
    t.text     "link"
  end

  create_table "discussion_threads", id: :bigserial, force: :cascade do |t|
    t.text     "title"
    t.text     "excerpt"
    t.text     "content"
    t.integer  "user_id",         limit: 8
    t.integer  "thread_count",    limit: 8
    t.integer  "level",           limit: 8, default: 1
    t.text     "slug"
    t.boolean  "published"
    t.text     "perlink"
    t.text     "edit_permission",           default: "free"
    t.datetime "deleted_at"
    t.boolean  "deleted",                   default: false
    t.boolean  "featured"
    t.text     "uuid"
    t.boolean  "test"
    t.datetime "published_at"
    t.datetime "commented_at"
    t.boolean  "early_access"
    t.text     "topic"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.text     "realm"
    t.text     "sub_realm"
    t.integer  "creator_id",      limit: 8
    t.boolean  "complete",                  default: false
    t.integer  "discussion_id",   limit: 8
    t.integer  "level_2_id",      limit: 8
    t.integer  "level_3_id",      limit: 8
    t.integer  "level_4_id",      limit: 8
    t.integer  "level_1_id",      limit: 8
    t.integer  "parent_id",       limit: 8
  end

  create_table "discussions", id: :bigserial, force: :cascade do |t|
    t.text     "title"
    t.text     "excerpt"
    t.text     "content"
    t.integer  "user_id",               limit: 8
    t.integer  "thread_count",          limit: 8
    t.text     "slug"
    t.boolean  "published"
    t.text     "perlink"
    t.text     "edit_permission",                 default: "free"
    t.datetime "deleted_at"
    t.boolean  "deleted",                         default: false
    t.boolean  "featured"
    t.text     "uuid"
    t.boolean  "test"
    t.datetime "published_at"
    t.datetime "commented_at"
    t.boolean  "early_access"
    t.text     "topic"
    t.integer  "level",                 limit: 8, default: 1
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
    t.text     "realm"
    t.text     "sub_realm"
    t.integer  "creator_id",            limit: 8
    t.boolean  "complete",                        default: false
    t.integer  "goal",                  limit: 8
    t.text     "review_status",                   default: "Pending"
    t.datetime "reviewed_at"
    t.boolean  "post_to_facebook",                default: false
    t.boolean  "post_to_facebook_page",           default: false
    t.text     "facebookupdate_id"
    t.boolean  "abandoned"
    t.boolean  "featured_home",                   default: false
    t.boolean  "listed"
  end

  create_table "donations", force: :cascade do |t|
    t.integer  "backer_id"
    t.integer  "backed_id"
    t.decimal  "amount",                 precision: 10, scale: 2
    t.datetime "deleted_at"
    t.decimal  "accumulated_receive",    precision: 10, scale: 2
    t.decimal  "accumulated_ratafire",   precision: 10, scale: 2
    t.decimal  "accumulated_total",      precision: 10, scale: 2
    t.integer  "subscription_record_id"
    t.integer  "project_id"
    t.integer  "deleted_reason"
    t.datetime "activated_at"
    t.boolean  "activated"
    t.boolean  "deleted"
    t.text     "uuid"
    t.integer  "counter"
    t.integer  "facebook_page_id"
    t.integer  "order_id"
    t.decimal  "accumulated_fee",        precision: 10, scale: 2, default: 0.0
    t.datetime "created_at",                                                    null: false
    t.datetime "updated_at",                                                    null: false
  end

  create_table "facebook_pages", id: :bigserial, force: :cascade do |t|
    t.text     "likes"
    t.text     "website"
    t.text     "username"
    t.text     "name"
    t.text     "mission"
    t.text     "location"
    t.boolean  "is_published"
    t.boolean  "is_permanently_closed"
    t.boolean  "is_community_page"
    t.text     "hometown"
    t.text     "global_brand_page_name"
    t.text     "genre"
    t.text     "general_manager"
    t.text     "test"
    t.text     "general_info"
    t.text     "founded"
    t.text     "email"
    t.text     "directed_by"
    t.text     "description"
    t.text     "current_location"
    t.text     "cover"
    t.text     "contact_address"
    t.text     "company_overview"
    t.text     "category"
    t.text     "booking_agent"
    t.text     "bio"
    t.text     "awards"
    t.text     "attire"
    t.text     "artists_we_like"
    t.text     "app_id"
    t.text     "affiliation"
    t.text     "access_token"
    t.text     "about"
    t.text     "page_id"
    t.integer  "facebook_id",                  limit: 8
    t.integer  "user_id",                      limit: 8
    t.datetime "deleted_at"
    t.boolean  "deleted"
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
    t.text     "uid"
    t.text     "city"
    t.text     "country"
    t.text     "state"
    t.text     "link"
    t.text     "uuid"
    t.text     "facebookprofile_file_name"
    t.text     "facebookprofile_content_type"
    t.integer  "facebookprofile_file_size",    limit: 8
    t.datetime "facebookprofile_updated_at"
    t.text     "facebookcover_file_name"
    t.text     "facebookcover_content_type"
    t.integer  "facebookcover_file_size",      limit: 8
    t.datetime "facebookcover_updated_at"
    t.boolean  "sync"
    t.boolean  "post_to_facebook_page"
    t.boolean  "project_facebook",                       default: true
  end

  create_table "facebookpages", id: :bigserial, force: :cascade do |t|
    t.text     "title"
    t.text     "tagline"
    t.integer  "user_id",                      limit: 8
    t.boolean  "complete"
    t.text     "about"
    t.integer  "creator_id",                   limit: 8
    t.text     "slug"
    t.boolean  "published"
    t.integer  "artwork_id",                   limit: 8
    t.text     "perlink"
    t.text     "video_id"
    t.integer  "icon_id",                      limit: 8
    t.integer  "goal",                         limit: 8
    t.text     "source_code"
    t.text     "source_code_type"
    t.text     "source_code_title"
    t.text     "excerpt"
    t.text     "edit_permission"
    t.boolean  "flag"
    t.datetime "completion_time"
    t.text     "realm"
    t.datetime "comented_at"
    t.boolean  "abandoned",                              default: false
    t.datetime "deleted_at"
    t.boolean  "deleted",                                default: false
    t.boolean  "featured",                               default: false
    t.text     "uuid"
    t.boolean  "test"
    t.datetime "published_at"
    t.boolean  "early_access",                           default: false
    t.integer  "audio_id",                     limit: 8
    t.integer  "pdf_id",                       limit: 8
    t.boolean  "featured_home",                          default: false
    t.text     "sub_realm"
    t.text     "collectible"
    t.text     "website"
    t.text     "username"
    t.text     "name"
    t.text     "mission"
    t.text     "location"
    t.text     "category"
    t.text     "access_token"
    t.text     "page_id"
    t.integer  "facebook_id",                  limit: 8
    t.text     "city"
    t.text     "country"
    t.text     "state"
    t.text     "link"
    t.datetime "created_at",                                             null: false
    t.datetime "updated_at",                                             null: false
    t.text     "facebookprofile_file_name"
    t.text     "facebookprofile_content_type"
    t.integer  "facebookprofile_file_size",    limit: 8
    t.datetime "facebookprofile_updated_at"
    t.text     "facebookcover_file_name"
    t.text     "facebookcover_content_type"
    t.integer  "facebookcover_file_size",      limit: 8
    t.datetime "facebookcover_updated_at"
    t.boolean  "sync"
    t.boolean  "project_facebook",                       default: true
    t.text     "collectible_20"
    t.text     "collectible_50"
    t.text     "collectible_100"
    t.boolean  "masked"
    t.text     "memorized_fullname"
    t.integer  "facebook_page_id",             limit: 8
  end

  create_table "facebooks", id: :bigserial, force: :cascade do |t|
    t.text     "uid"
    t.text     "name"
    t.text     "first_name"
    t.text     "last_name"
    t.text     "link"
    t.text     "username"
    t.text     "gender"
    t.text     "locale"
    t.integer  "age_min",           limit: 8
    t.integer  "age_max",           limit: 8
    t.integer  "user_id",           limit: 8
    t.text     "oauth_token"
    t.text     "oauth_expires_at"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.text     "user_birthday"
    t.text     "email"
    t.text     "image"
    t.text     "bio"
    t.text     "location"
    t.text     "website"
    t.text     "school"
    t.text     "concentration"
    t.text     "page_access_token"
    t.boolean  "deleted"
    t.datetime "deleted_at"
    t.text     "post_access_token"
  end

  create_table "facebookupdates", id: :bigserial, force: :cascade do |t|
    t.integer  "user_id",                    limit: 8
    t.boolean  "deleted"
    t.datetime "deleted_at"
    t.integer  "facebook_id",                limit: 8
    t.integer  "facebookpage_id",            limit: 8
    t.text     "uid"
    t.text     "from_category"
    t.text     "from_name"
    t.text     "from_id"
    t.text     "message"
    t.text     "story"
    t.text     "picture"
    t.text     "link"
    t.text     "source"
    t.text     "caption"
    t.text     "video_description"
    t.text     "post_type"
    t.text     "facebook_link"
    t.text     "event_name"
    t.text     "object_id"
    t.text     "status_type"
    t.text     "uuid"
    t.text     "page_id"
    t.text     "youtube_video"
    t.text     "vimeo_video"
    t.text     "name"
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
    t.text     "picture_file_name"
    t.text     "picture_content_type"
    t.integer  "picture_file_size",          limit: 8
    t.datetime "picture_updated_at"
    t.text     "description"
    t.text     "facebookimage_file_name"
    t.text     "facebookimage_content_type"
    t.integer  "facebookimage_file_size",    limit: 8
    t.datetime "facebookimage_updated_at"
    t.boolean  "valid_update",                         default: true
    t.text     "html_display"
    t.text     "realm"
    t.text     "sub_realm"
    t.boolean  "featured",                             default: false
    t.boolean  "featured_home",                        default: false
    t.boolean  "listed"
    t.boolean  "test",                                 default: true
  end

  create_table "friendly_id_slugs", id: :bigserial, force: :cascade do |t|
    t.text     "slug",                     null: false
    t.integer  "sluggable_id",   limit: 8, null: false
    t.text     "sluggable_type"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "idx_16710_index_friendly_id_slugs_on_slug_and_sluggable_type", unique: true, using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "idx_16710_index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "idx_16710_index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "friendships", id: :bigserial, force: :cascade do |t|
    t.integer  "user_id",             limit: 8
    t.integer  "friend_id",           limit: 8
    t.boolean  "deleted"
    t.datetime "deleted_at"
    t.text     "user_facebook_uid"
    t.text     "friend_facebook_uid"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "friendship_init",     limit: 8
  end

  create_table "githubs", id: :bigserial, force: :cascade do |t|
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "user_id",      limit: 8
    t.text     "uid"
    t.text     "email"
    t.text     "image"
    t.text     "link"
    t.text     "oauth_token"
    t.text     "username"
    t.text     "name"
    t.text     "hireable"
    t.text     "public_repos"
  end

  create_table "ibifrosts", id: :bigserial, force: :cascade do |t|
    t.integer  "project_id", limit: 8
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "icons", id: :bigserial, force: :cascade do |t|
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
    t.text     "image_file_name"
    t.text     "image_content_type"
    t.integer  "image_file_size",             limit: 8
    t.datetime "image_updated_at"
    t.integer  "project_id",                  limit: 8
    t.text     "content_temp"
    t.text     "tags_temp"
    t.integer  "archive_id",                  limit: 8
    t.text     "direct_upload_url",                                     null: false
    t.boolean  "processed",                             default: false, null: false
    t.integer  "user_id",                     limit: 8,                 null: false
    t.boolean  "skip_everafter",                        default: false
    t.integer  "organization_id",             limit: 8
    t.integer  "organization_application_id", limit: 8
  end

  add_index "icons", ["processed"], name: "idx_16743_index_icons_on_processed", using: :btree
  add_index "icons", ["user_id"], name: "idx_16743_index_icons_on_user_id", using: :btree

  create_table "inviteds", id: :bigserial, force: :cascade do |t|
    t.integer  "project_id",  limit: 8
    t.integer  "user_id",     limit: 8
    t.text     "username"
    t.boolean  "accept",                default: false
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "ibifrost_id", limit: 8
  end

  create_table "liked_activities", id: :bigserial, force: :cascade do |t|
    t.integer  "user_id",     limit: 8
    t.integer  "activity_id", limit: 8
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.text     "type"
  end

  create_table "liked_comments", id: :bigserial, force: :cascade do |t|
    t.integer  "comment_id",         limit: 8
    t.integer  "user_id",            limit: 8
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "project_comment_id", limit: 8
  end

  create_table "liked_majorposts", id: :bigserial, force: :cascade do |t|
    t.integer  "majorpost_id", limit: 8
    t.integer  "user_id",      limit: 8
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "liked_projects", id: :bigserial, force: :cascade do |t|
    t.integer  "project_id", limit: 8
    t.integer  "user_id",    limit: 8
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "liker_id",   limit: 8
  end

  create_table "links", force: :cascade do |t|
    t.string   "image_best"
    t.text     "description"
    t.string   "best_title"
    t.string   "title"
    t.string   "root_url"
    t.string   "host"
    t.boolean  "tracked"
    t.string   "url"
    t.string   "majorpost_uuid"
    t.boolean  "deleted"
    t.datetime "deleted_at"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "uuid"
    t.integer  "user_id"
  end

  create_table "m_e_inspirations", id: :bigserial, force: :cascade do |t|
    t.integer  "inspired_id", limit: 8
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "url"
    t.text     "title"
  end

  create_table "m_m_inspirations", id: :bigserial, force: :cascade do |t|
    t.integer  "inspirer_id",                 limit: 8
    t.integer  "inspired_id",                 limit: 8
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.text     "inspired_majorpost_title"
    t.text     "inspirer_majorpost_title"
    t.text     "inspirer_majorpost_username"
  end

  add_index "m_m_inspirations", ["inspired_id"], name: "idx_16915_index_m_m_inspirations_on_inspired_id", using: :btree
  add_index "m_m_inspirations", ["inspirer_id", "inspired_id"], name: "idx_16915_index_m_m_inspirations_on_inspirer_id_and_inspired_id", unique: true, using: :btree
  add_index "m_m_inspirations", ["inspirer_id"], name: "idx_16915_index_m_m_inspirations_on_inspirer_id", using: :btree

  create_table "m_p_inspirations", id: :bigserial, force: :cascade do |t|
    t.integer  "inspirer_id",              limit: 8
    t.integer  "inspired_id",              limit: 8
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "project_title"
    t.text     "project_creator_username"
  end

  create_table "m_u_inspirations", id: :bigserial, force: :cascade do |t|
    t.integer  "inspirer_id",   limit: 8
    t.integer  "inspired_id",   limit: 8
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "user_username"
  end

  create_table "mailboxer_conversation_opt_outs", id: :bigserial, force: :cascade do |t|
    t.integer "unsubscriber_id",   limit: 8
    t.text    "unsubscriber_type"
    t.integer "conversation_id",   limit: 8
  end

  add_index "mailboxer_conversation_opt_outs", ["conversation_id"], name: "idx_16803_mb_opt_outs_on_conversations_id", using: :btree

  create_table "mailboxer_conversations", id: :bigserial, force: :cascade do |t|
    t.text     "subject",    default: ""
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "blocked",    default: false
    t.boolean  "not_accept", default: false
  end

  create_table "mailboxer_notifications", id: :bigserial, force: :cascade do |t|
    t.text     "type"
    t.text     "body"
    t.text     "subject",                        default: ""
    t.integer  "sender_id",            limit: 8
    t.text     "sender_type"
    t.integer  "conversation_id",      limit: 8
    t.boolean  "draft",                          default: false
    t.text     "notification_code"
    t.integer  "notified_object_id",   limit: 8
    t.text     "notified_object_type"
    t.text     "attachment"
    t.datetime "updated_at",                                     null: false
    t.datetime "created_at",                                     null: false
    t.boolean  "global",                         default: false
    t.datetime "expires"
  end

  add_index "mailboxer_notifications", ["conversation_id"], name: "idx_16812_index_mailboxer_notifications_on_conversation_id", using: :btree

  create_table "mailboxer_receipts", id: :bigserial, force: :cascade do |t|
    t.integer  "receiver_id",     limit: 8
    t.text     "receiver_type"
    t.integer  "notification_id", limit: 8,                 null: false
    t.boolean  "is_read",                   default: false
    t.boolean  "trashed",                   default: false
    t.boolean  "deleted",                   default: false
    t.text     "mailbox_type"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.boolean  "blocked",                   default: false
    t.boolean  "not_accept",                default: false
  end

  add_index "mailboxer_receipts", ["notification_id"], name: "idx_16824_index_mailboxer_receipts_on_notification_id", using: :btree

  create_table "majorpost_suggestions", id: :bigserial, force: :cascade do |t|
    t.text     "term"
    t.integer  "popularity", limit: 8
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "majorposts", id: :bigserial, force: :cascade do |t|
    t.text     "content"
    t.integer  "user_id",               limit: 8
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "project_id",            limit: 8
    t.text     "title"
    t.text     "artwork_id"
    t.boolean  "published",                       default: true
    t.integer  "video_id",              limit: 8
    t.text     "excerpt"
    t.text     "edit_permission",                 default: "free"
    t.boolean  "archived",                        default: false
    t.datetime "commented_at"
    t.datetime "deleted_at"
    t.boolean  "deleted",                         default: false
    t.boolean  "featured"
    t.text     "uuid"
    t.boolean  "test",                            default: false
    t.datetime "published_at"
    t.boolean  "early_access",                    default: false
    t.integer  "audio_id",              limit: 8
    t.integer  "pdf_id",                limit: 8
    t.text     "realm"
    t.text     "sub_realm"
    t.boolean  "post_to_facebook",                default: false
    t.boolean  "post_to_facebook_page",           default: false
    t.text     "facebookupdate_id"
    t.boolean  "abandoned"
    t.boolean  "featured_home",                   default: false
    t.boolean  "listed"
    t.text     "license"
    t.string   "post_type",                       default: "text"
    t.boolean  "paid_update",                     default: false
    t.string   "composer"
    t.string   "artist"
    t.string   "genre"
  end

  create_table "masspay_batches", id: :bigserial, force: :cascade do |t|
    t.boolean  "deleted"
    t.datetime "deleted_at"
    t.boolean  "transfered"
    t.datetime "transfered_at"
    t.text     "complete_response"
    t.text     "error_short_message"
    t.text     "error_long_message"
    t.text     "error_code"
    t.text     "ack"
    t.text     "correlation_id"
    t.boolean  "error"
    t.decimal  "amount",                        precision: 10, scale: 2, default: 0.0
    t.decimal  "fee",                           precision: 10, scale: 2, default: 0.0
    t.decimal  "receive",                       precision: 10, scale: 2, default: 0.0
    t.datetime "created_at",                                                           null: false
    t.datetime "updated_at",                                                           null: false
    t.integer  "on_hold",             limit: 8,                          default: 0
  end

  create_table "masspay_errors", id: :bigserial, force: :cascade do |t|
    t.text     "error_code"
    t.text     "error_long_message"
    t.text     "error_short_message"
    t.boolean  "corrected"
    t.datetime "corrected_at"
    t.boolean  "deteled"
    t.datetime "deleted_at"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "masspay_batch_id",    limit: 8
  end

  create_table "masspay_logs", id: :bigserial, force: :cascade do |t|
    t.boolean  "deleted"
    t.datetime "deleted_at"
    t.decimal  "amount",                   precision: 10, scale: 2, default: 0.0
    t.integer  "count",          limit: 8,                          default: 0
    t.datetime "created_at",                                                      null: false
    t.datetime "updated_at",                                                      null: false
    t.text     "correlation_id"
  end

  create_table "messages", id: :bigserial, force: :cascade do |t|
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.text     "title"
    t.text     "content"
    t.integer  "receiver_id",     limit: 8
    t.integer  "sender_id",       limit: 8
    t.integer  "conversation_id", limit: 8
  end

  create_table "orders", id: :bigserial, force: :cascade do |t|
    t.integer  "user_id",       limit: 8
    t.decimal  "amount",                  precision: 10, scale: 2, default: 0.0
    t.boolean  "transacted"
    t.datetime "transacted_at"
    t.boolean  "deleted"
    t.datetime "deleted_at"
    t.datetime "created_at",                                                     null: false
    t.datetime "updated_at",                                                     null: false
    t.integer  "count",         limit: 8,                          default: 0
  end

  create_table "organization_applications", id: :bigserial, force: :cascade do |t|
    t.text     "name"
    t.integer  "user_id",                  limit: 8
    t.text     "collectible"
    t.text     "about"
    t.text     "location"
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.text     "icon_file_name"
    t.text     "icon_content_type"
    t.integer  "icon_file_size",           limit: 8
    t.datetime "icon_updated_at"
    t.text     "status"
    t.boolean  "deleted"
    t.datetime "deleted_at"
    t.integer  "step",                     limit: 8, default: 1
    t.integer  "goal_subscription_amount", limit: 8, default: 7730
  end

  create_table "organization_paypal_accounts", id: :bigserial, force: :cascade do |t|
    t.integer  "user_id",                     limit: 8
    t.boolean  "deleted"
    t.datetime "deleted_at"
    t.text     "name"
    t.text     "email"
    t.text     "first_name"
    t.text     "last_name"
    t.text     "location"
    t.text     "phone"
    t.text     "token"
    t.text     "refresh_token"
    t.text     "expires_at"
    t.boolean  "expires"
    t.text     "account_creation_date"
    t.text     "account_type"
    t.text     "user_identity"
    t.text     "country"
    t.text     "locality"
    t.text     "postal_code"
    t.text     "region"
    t.text     "street_address"
    t.text     "language"
    t.text     "locale"
    t.boolean  "verified_account"
    t.text     "zoneinfo"
    t.text     "age_range"
    t.text     "birthday"
    t.integer  "retry",                       limit: 8
    t.text     "uid"
    t.integer  "organization_id",             limit: 8
    t.integer  "organization_application_id", limit: 8
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  create_table "organization_subscriptions", id: :bigserial, force: :cascade do |t|
    t.integer  "organization_id",        limit: 8
    t.integer  "subscriber_id",          limit: 8
    t.decimal  "amount",                           precision: 10, scale: 2, default: 0.0
    t.datetime "deleted_at"
    t.decimal  "accumulated_receive",              precision: 10, scale: 2, default: 0.0
    t.decimal  "accumulated_total",                precision: 10, scale: 2, default: 0.0
    t.integer  "subscription_record_id", limit: 8
    t.datetime "activated_at"
    t.boolean  "activated",                                                 default: false
    t.boolean  "deleted"
    t.text     "uuid"
    t.integer  "counter",                limit: 8
    t.text     "method"
    t.decimal  "accumulated_fee",                  precision: 10, scale: 2, default: 0.0
    t.integer  "deleted_reason",         limit: 8
    t.datetime "created_at",                                                                null: false
    t.datetime "updated_at",                                                                null: false
  end

  create_table "organizations", id: :bigserial, force: :cascade do |t|
    t.boolean  "deleted"
    t.datetime "deleted_at"
    t.text     "uuid"
    t.text     "website"
    t.integer  "leader_id",                   limit: 8
    t.text     "about"
    t.text     "subscription_status_initial"
    t.datetime "goals_updated_at"
    t.decimal  "subscription_amount",                   precision: 8, scale: 2, default: 0.0
    t.datetime "created_at",                                                                   null: false
    t.datetime "updated_at",                                                                   null: false
    t.text     "icon_file_name"
    t.text     "icon_content_type"
    t.integer  "icon_file_size",              limit: 8
    t.datetime "icon_updated_at"
    t.text     "background_file_name"
    t.text     "background_content_type"
    t.integer  "background_file_size",        limit: 8
    t.datetime "background_updated_at"
    t.text     "collectible"
    t.text     "location"
    t.text     "perlink"
    t.integer  "goal_subscription_amount",    limit: 8,                         default: 7730
  end

  create_table "p_e_inspirations", id: :bigserial, force: :cascade do |t|
    t.integer  "inspired_id", limit: 8
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "url"
    t.text     "title"
  end

  create_table "p_m_inspirations", id: :bigserial, force: :cascade do |t|
    t.integer  "inspirer_id",        limit: 8
    t.integer  "inspired_id",        limit: 8
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "project_title"
    t.text     "majorpost_title"
    t.text     "majorpost_username"
  end

  create_table "p_p_inspirations", id: :bigserial, force: :cascade do |t|
    t.integer  "inspirer_id",               limit: 8
    t.integer  "inspired_id",               limit: 8
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.text     "inspirer_project_title"
    t.text     "inspired_project_title"
    t.text     "inspirer_project_username"
  end

  add_index "p_p_inspirations", ["inspired_id"], name: "idx_17111_index_p_p_inspirations_on_inspired_id", using: :btree
  add_index "p_p_inspirations", ["inspirer_id", "inspired_id"], name: "idx_17111_index_p_p_inspirations_on_inspirer_id_and_inspired_id", unique: true, using: :btree
  add_index "p_p_inspirations", ["inspirer_id"], name: "idx_17111_index_p_p_inspirations_on_inspirer_id", using: :btree

  create_table "p_u_inspirations", id: :bigserial, force: :cascade do |t|
    t.integer  "inspirer_id",   limit: 8
    t.integer  "inspired_id",   limit: 8
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.text     "user_username"
  end

  add_index "p_u_inspirations", ["inspired_id"], name: "idx_17120_index_p_u_inspirations_on_inspired_id", using: :btree
  add_index "p_u_inspirations", ["inspirer_id", "inspired_id"], name: "idx_17120_index_p_u_inspirations_on_inspirer_id_and_inspired_id", unique: true, using: :btree
  add_index "p_u_inspirations", ["inspirer_id"], name: "idx_17120_index_p_u_inspirations_on_inspirer_id", using: :btree

  create_table "patron_videos", id: :bigserial, force: :cascade do |t|
    t.boolean  "deleted"
    t.boolean  "deleted_at"
    t.integer  "user_id",         limit: 8
    t.integer  "video_id",        limit: 8
    t.text     "review"
    t.integer  "admin_id",        limit: 8
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.text     "status",                    default: "Pending"
    t.integer  "organization_id", limit: 8
  end

  create_table "payments", id: :bigserial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "paypal_accounts", id: :bigserial, force: :cascade do |t|
    t.integer  "user_id",                     limit: 8
    t.boolean  "deleted"
    t.datetime "deleted_at"
    t.text     "name"
    t.text     "email"
    t.text     "first_name"
    t.text     "last_name"
    t.text     "location"
    t.text     "phone"
    t.text     "token"
    t.text     "refresh_token"
    t.text     "expires_at"
    t.boolean  "expires"
    t.text     "account_creation_date"
    t.text     "account_type"
    t.text     "user_identity"
    t.text     "country"
    t.text     "locality"
    t.text     "postal_code"
    t.text     "region"
    t.text     "street_address"
    t.text     "language"
    t.text     "locale"
    t.boolean  "verified_account"
    t.text     "zoneinfo"
    t.text     "age_range"
    t.text     "birthday"
    t.integer  "retry",                       limit: 8
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.text     "uid"
    t.integer  "organization_id",             limit: 8
    t.integer  "organization_application_id", limit: 8
  end

  create_table "pdfs", id: :bigserial, force: :cascade do |t|
    t.text     "title"
    t.integer  "majorpost_id",      limit: 8
    t.integer  "project_id",        limit: 8
    t.integer  "archive_id",        limit: 8
    t.text     "direct_upload_url",                           null: false
    t.boolean  "processed",                   default: false, null: false
    t.integer  "user_id",           limit: 8,                 null: false
    t.boolean  "skip_everafter",              default: false
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.text     "content_temp"
    t.text     "tags_temp"
    t.text     "pdf_file_name"
    t.text     "pdf_content_type"
    t.integer  "pdf_file_size",     limit: 8
    t.datetime "pdf_updated_at"
  end

  create_table "pinterests", force: :cascade do |t|
    t.integer  "user_id"
    t.boolean  "deleted"
    t.datetime "deleted_at"
    t.string   "uid"
    t.string   "pinterest_id"
    t.string   "url"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "profilephotos", force: :cascade do |t|
    t.boolean  "deleted"
    t.datetime "deleted_at"
    t.integer  "user_id"
    t.string   "user_uid"
    t.string   "source"
    t.string   "uuid"
    t.string   "direct_upload_url"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.boolean  "processed"
    t.boolean  "skip_everafter"
  end

  create_table "project_comments", id: :bigserial, force: :cascade do |t|
    t.text     "content"
    t.integer  "user_id",                 limit: 8
    t.integer  "project_id",              limit: 8
    t.text     "excerpt"
    t.datetime "deleted_at"
    t.boolean  "deleted",                           default: false
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.integer  "stars",                   limit: 8, default: 0
    t.text     "title"
    t.integer  "cached_votes_total",      limit: 8, default: 0
    t.integer  "cached_votes_score",      limit: 8, default: 0
    t.integer  "cached_votes_up",         limit: 8, default: 0
    t.integer  "cached_votes_down",       limit: 8, default: 0
    t.integer  "cached_weighted_score",   limit: 8, default: 0
    t.integer  "cached_weighted_total",   limit: 8, default: 0
    t.float    "cached_weighted_average"
  end

  add_index "project_comments", ["cached_votes_down"], name: "idx_17066_index_project_comments_on_cached_votes_down", using: :btree
  add_index "project_comments", ["cached_votes_score"], name: "idx_17066_index_project_comments_on_cached_votes_score", using: :btree
  add_index "project_comments", ["cached_votes_total"], name: "idx_17066_index_project_comments_on_cached_votes_total", using: :btree
  add_index "project_comments", ["cached_votes_up"], name: "idx_17066_index_project_comments_on_cached_votes_up", using: :btree
  add_index "project_comments", ["cached_weighted_average"], name: "idx_17066_index_project_comments_on_cached_weighted_average", using: :btree
  add_index "project_comments", ["cached_weighted_score"], name: "idx_17066_index_project_comments_on_cached_weighted_score", using: :btree
  add_index "project_comments", ["cached_weighted_total"], name: "idx_17066_index_project_comments_on_cached_weighted_total", using: :btree

  create_table "project_suggestions", id: :bigserial, force: :cascade do |t|
    t.text     "term"
    t.integer  "popularity", limit: 8
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "projects", id: :bigserial, force: :cascade do |t|
    t.text     "title"
    t.text     "tagline"
    t.integer  "user_id",               limit: 8
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "complete"
    t.text     "about"
    t.integer  "creator_id",            limit: 8
    t.text     "slug"
    t.boolean  "published"
    t.integer  "artwork_id",            limit: 8
    t.text     "perlink"
    t.text     "video_id"
    t.integer  "icon_id",               limit: 8
    t.integer  "goal",                  limit: 8
    t.text     "source_code"
    t.text     "source_code_type"
    t.text     "source_code_title"
    t.text     "excerpt"
    t.text     "edit_permission"
    t.boolean  "flag"
    t.datetime "completion_time"
    t.text     "realm"
    t.datetime "commented_at"
    t.boolean  "abandoned",                       default: false
    t.datetime "deleted_at"
    t.boolean  "deleted",                         default: false
    t.boolean  "featured",                        default: false
    t.text     "uuid"
    t.boolean  "test",                            default: false
    t.datetime "published_at"
    t.boolean  "early_access",                    default: false
    t.integer  "audio_id",              limit: 8
    t.integer  "pdf_id",                limit: 8
    t.boolean  "featured_home",                   default: false
    t.text     "sub_realm"
    t.text     "collectible"
    t.boolean  "post_to_facebook",                default: false
    t.boolean  "post_to_facebook_page",           default: false
    t.text     "facebookupdate_id"
    t.boolean  "listed"
    t.boolean  "project_facebook"
    t.text     "license"
    t.text     "collectible_20"
    t.text     "collectible_50"
    t.text     "collectible_100"
  end

  create_table "quotes", id: :bigserial, force: :cascade do |t|
    t.text     "content"
    t.text     "by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rates", id: :bigserial, force: :cascade do |t|
    t.integer  "rater_id",      limit: 8
    t.integer  "rateable_id",   limit: 8
    t.text     "rateable_type"
    t.float    "stars",                   null: false
    t.text     "dimension"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "rates", ["rateable_id", "rateable_type"], name: "idx_17138_index_rates_on_rateable_id_and_rateable_type", using: :btree
  add_index "rates", ["rater_id"], name: "idx_17138_index_rates_on_rater_id", using: :btree

  create_table "rating_caches", id: :bigserial, force: :cascade do |t|
    t.integer  "cacheable_id",   limit: 8
    t.text     "cacheable_type"
    t.float    "avg",                                  null: false
    t.integer  "qty",            limit: 8,             null: false
    t.text     "dimension"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.integer  "star_1_qty",     limit: 8, default: 0
    t.float    "star_1_per"
    t.integer  "star_2_qty",     limit: 8, default: 0
    t.float    "star_2_per"
    t.integer  "star_3_qty",     limit: 8, default: 0
    t.float    "star_3_per"
    t.integer  "star_4_qty",     limit: 8, default: 0
    t.float    "star_4_per"
    t.integer  "star_5_qty",     limit: 8, default: 0
    t.float    "star_5_per"
    t.integer  "project_id",     limit: 8
  end

  add_index "rating_caches", ["cacheable_id", "cacheable_type"], name: "idx_17154_index_rating_caches_on_cacheable_id_and_cacheable_typ", using: :btree

  create_table "ratings", id: :bigserial, force: :cascade do |t|
    t.integer  "project_id", limit: 8
    t.integer  "user_id",    limit: 8
    t.float    "stars"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "recipients", id: :bigserial, force: :cascade do |t|
    t.integer  "user_id",         limit: 8
    t.text     "recipient_id"
    t.text     "object"
    t.boolean  "livemode"
    t.text     "klass"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.boolean  "deleted"
    t.datetime "deleted_at"
    t.text     "tax_id"
    t.text     "email"
    t.text     "name"
    t.boolean  "verified"
    t.text     "country"
    t.text     "routing_number"
    t.text     "account_number"
    t.text     "last4"
    t.text     "exp_mongth"
    t.text     "exp_year"
    t.text     "cvc"
    t.text     "card_name"
    t.text     "address_line1"
    t.text     "address_line2"
    t.text     "address_city"
    t.text     "address_zip"
    t.text     "address_state"
    t.text     "address_country"
    t.text     "description"
    t.text     "account_id"
    t.text     "bank_name"
    t.text     "fingerprint"
    t.text     "account_status"
    t.integer  "transfer_id",     limit: 8
  end

  create_table "redactor_assets", id: :bigserial, force: :cascade do |t|
    t.integer  "user_id",           limit: 8
    t.text     "data_file_name",              null: false
    t.text     "data_content_type"
    t.integer  "data_file_size",    limit: 8
    t.integer  "assetable_id",      limit: 8
    t.text     "assetable_type"
    t.text     "type"
    t.integer  "width",             limit: 8
    t.integer  "height",            limit: 8
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "redactor_assets", ["assetable_type", "assetable_id"], name: "idx_17182_idx_redactor_assetable", using: :btree
  add_index "redactor_assets", ["assetable_type", "type", "assetable_id"], name: "idx_17182_idx_redactor_assetable_type", using: :btree

  create_table "reviews", id: :bigserial, force: :cascade do |t|
    t.integer  "project_id",                  limit: 8
    t.integer  "discussion_id",               limit: 8
    t.text     "content"
    t.text     "title"
    t.integer  "user_id",                     limit: 8
    t.boolean  "admin_review",                          default: false
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
    t.datetime "deleted_at"
    t.boolean  "deleted"
    t.text     "message"
    t.text     "status"
    t.integer  "subscription_application_id", limit: 8
    t.boolean  "skip_countdown",                        default: false
  end

  create_table "secrets", id: :bigserial, force: :cascade do |t|
    t.text     "status"
    t.integer  "user_id",        limit: 8
    t.text     "title"
    t.text     "description"
    t.text     "location"
    t.boolean  "deleted"
    t.datetime "deleted_at"
    t.decimal  "value",                    precision: 10, scale: 2, default: 2.0
    t.text     "category"
    t.text     "namecode"
    t.datetime "created_at",                                                      null: false
    t.datetime "updated_at",                                                      null: false
    t.text     "mailer_message"
  end

  create_table "subscription_applications", id: :bigserial, force: :cascade do |t|
    t.text     "why"
    t.text     "plan"
    t.text     "different"
    t.text     "status"
    t.integer  "user_id",              limit: 8
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.datetime "approved_at"
    t.datetime "deadline"
    t.integer  "step",                 limit: 8
    t.integer  "goals_subscribers",    limit: 8
    t.integer  "goals_monthly",        limit: 8
    t.integer  "goals_project",        limit: 8
    t.text     "collectible"
    t.integer  "project_id",           limit: 8
    t.datetime "completed_at"
    t.boolean  "completion"
    t.integer  "ssn",                  limit: 8
    t.integer  "routing_number",       limit: 8
    t.integer  "account_number",       limit: 8
    t.boolean  "facebookpage_clicked"
    t.integer  "facebookpage_id",      limit: 8
    t.text     "collectible_20"
    t.text     "collectible_50"
    t.text     "collectible_100"
  end

  create_table "subscription_records", id: :bigserial, force: :cascade do |t|
    t.integer  "subscriber_id",        limit: 8
    t.integer  "subscribed_id",        limit: 8
    t.decimal  "accumulated_receive",            precision: 10, scale: 2, default: 0.0
    t.decimal  "accumulated_amazon",             precision: 10, scale: 2, default: 0.0
    t.decimal  "accumulated_ratafire",           precision: 10, scale: 2, default: 0.0
    t.decimal  "accumulated_total",              precision: 10, scale: 2, default: 0.0
    t.datetime "created_at",                                                              null: false
    t.datetime "updated_at",                                                              null: false
    t.boolean  "past",                                                    default: false
    t.decimal  "duration",                       precision: 32, scale: 6
    t.boolean  "accumulated",                                             default: false
    t.boolean  "supporter_switch",                                        default: false
    t.boolean  "past_support",                                            default: false
    t.boolean  "duration_support",                                        default: false
    t.integer  "counter",              limit: 8,                          default: 0
    t.decimal  "accumulated_fee",                precision: 10, scale: 2, default: 0.0
  end

  create_table "subscriptions", id: :bigserial, force: :cascade do |t|
    t.integer  "subscriber_id",            limit: 8
    t.integer  "subscribed_id",            limit: 8
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "amount",                             precision: 10, scale: 2
    t.datetime "deleted_at"
    t.decimal  "accumulated_receive",                precision: 10, scale: 2, default: 0.0
    t.decimal  "accumulated_amazon",                 precision: 10, scale: 2, default: 0.0
    t.decimal  "accumulated_ratafire",               precision: 10, scale: 2, default: 0.0
    t.decimal  "accumulated_total",                  precision: 10, scale: 2, default: 0.0
    t.boolean  "amazon_valid",                                                default: false
    t.integer  "subscription_record_id",   limit: 8
    t.integer  "project_id",               limit: 8
    t.integer  "deleted_reason",           limit: 8
    t.datetime "activated_at"
    t.boolean  "activated",                                                   default: false
    t.boolean  "deleted",                                                     default: false
    t.text     "uuid"
    t.boolean  "supporter_switch",                                            default: false
    t.datetime "this_billing_date"
    t.datetime "next_billing_date"
    t.boolean  "first_payment",                                               default: false
    t.datetime "first_payment_created_at"
    t.integer  "counter",                  limit: 8,                          default: 0
    t.boolean  "next_transaction_queued",                                     default: false
    t.integer  "retry",                    limit: 8,                          default: 0
    t.text     "method"
    t.integer  "facebook_page_id",         limit: 8
    t.integer  "order_id",                 limit: 8
    t.decimal  "accumulated_fee",                    precision: 10, scale: 2, default: 0.0
  end

  create_table "tag_relationships", id: :bigserial, force: :cascade do |t|
    t.integer  "user_id",    limit: 8
    t.integer  "tag_id",     limit: 8
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "taggings", id: :bigserial, force: :cascade do |t|
    t.integer  "tag_id",        limit: 8
    t.integer  "taggable_id",   limit: 8
    t.text     "taggable_type"
    t.integer  "tagger_id",     limit: 8
    t.text     "tagger_type"
    t.text     "context"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "idx_17266_taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "idx_17266_index_taggings_on_taggable_id_and_taggable_type_and_c", using: :btree

  create_table "tags", id: :bigserial, force: :cascade do |t|
    t.text    "name"
    t.integer "taggings_count", limit: 8, default: 0
  end

  add_index "tags", ["name"], name: "idx_17275_index_tags_on_name", unique: true, using: :btree

  create_table "tags_suggestions", id: :bigserial, force: :cascade do |t|
    t.text     "term"
    t.integer  "popularity", limit: 8
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "thread_connectors", id: :bigserial, force: :cascade do |t|
    t.integer  "discussion_id", limit: 8
    t.integer  "level_1_id",    limit: 8
    t.integer  "level_2_id",    limit: 8
    t.integer  "level_3_id",    limit: 8
    t.integer  "level_4_id",    limit: 8
    t.integer  "level_5_id",    limit: 8
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "transactions", id: :bigserial, force: :cascade do |t|
    t.datetime "created_at",                                                                   null: false
    t.decimal  "receive",                           precision: 10, scale: 2
    t.decimal  "amazon",                            precision: 10, scale: 2
    t.integer  "ratafire",                limit: 8
    t.decimal  "total",                             precision: 10, scale: 2
    t.boolean  "sucess"
    t.integer  "subscriber_id",           limit: 8
    t.integer  "subscribed_id",           limit: 8
    t.datetime "updated_at",                                                                   null: false
    t.text     "callerreference"
    t.text     "chargefeeto"
    t.text     "recipienttokenid"
    t.text     "sendertokenid"
    t.text     "transactionid"
    t.text     "statuscode"
    t.text     "statusmessage"
    t.text     "status",                                                     default: "Error"
    t.integer  "subscription_record_id",  limit: 8
    t.text     "amount"
    t.text     "uuid"
    t.decimal  "ratafire_fee",                      precision: 10, scale: 2
    t.text     "error"
    t.boolean  "supporter_switch",                                           default: false
    t.integer  "subscription_id",         limit: 8
    t.datetime "next_transaction"
    t.boolean  "next_transaction_status",                                    default: false
    t.integer  "counter",                 limit: 8,                          default: 0
    t.integer  "retry",                   limit: 8,                          default: 0
    t.decimal  "payment_fee",                       precision: 10, scale: 2, default: 0.0
    t.integer  "billing_subscription_id", limit: 8
    t.integer  "billing_artist_id",       limit: 8
    t.text     "created"
    t.boolean  "livemode"
    t.boolean  "paid"
    t.text     "currency"
    t.boolean  "refunded"
    t.text     "card_stripe_id"
    t.text     "customer_stripe_id"
    t.boolean  "captured"
    t.text     "balance_transaction"
    t.text     "failure_message"
    t.text     "failure_code"
    t.decimal  "amount_refunded",                   precision: 10, scale: 2, default: 0.0
    t.text     "recipient_stripe_id"
    t.boolean  "reversed"
    t.text     "klass"
    t.text     "stripe_id"
    t.text     "description"
    t.text     "method"
    t.text     "paypal_correlation_id"
    t.text     "billing_agreement_id"
    t.text     "paypal_transaction_id"
    t.decimal  "fee",                               precision: 10, scale: 2
    t.text     "venmo_transaction_id"
    t.text     "venmo_username"
    t.text     "venmo_token"
    t.integer  "transfer_id",             limit: 8
  end

  create_table "transfers", id: :bigserial, force: :cascade do |t|
    t.integer  "user_id",                       limit: 8
    t.integer  "subscription_id",               limit: 8
    t.integer  "subscription_record_id",        limit: 8
    t.integer  "billing_artist_id",             limit: 8
    t.integer  "recipient_id",                  limit: 8
    t.datetime "transfered_at"
    t.text     "status"
    t.integer  "retry",                         limit: 8,                          default: 0
    t.text     "statusmessage"
    t.text     "uuid"
    t.text     "error"
    t.boolean  "transfered"
    t.text     "paypal_correlation_id"
    t.text     "billing_agreement_id"
    t.text     "paypal_transaction_id"
    t.text     "venmo_transaction_id"
    t.text     "venmo_username"
    t.text     "venmo_token"
    t.text     "stripe_id"
    t.text     "method"
    t.text     "stripe_transfer_id"
    t.text     "stripe_destination_id"
    t.text     "test"
    t.text     "stripe_recipient_id"
    t.text     "stripe_balance_transaction_id"
    t.datetime "created_at",                                                                     null: false
    t.datetime "updated_at",                                                                     null: false
    t.boolean  "deleted"
    t.datetime "deleted_at"
    t.decimal  "fee",                                     precision: 10
    t.decimal  "receive",                                 precision: 10
    t.decimal  "amount",                                  precision: 10
    t.decimal  "ordered_amount",                          precision: 10, scale: 2, default: 0.0
    t.decimal  "collected_amount",                        precision: 10, scale: 2, default: 0.0
    t.decimal  "collected_fee",                           precision: 10, scale: 2, default: 0.0
    t.decimal  "collected_receive",                       precision: 10, scale: 2, default: 0.0
    t.boolean  "on_hold"
    t.integer  "masspay_batch_id",              limit: 8
    t.boolean  "queued"
    t.boolean  "completed"
    t.datetime "completed_at"
    t.decimal  "transfer_amount",                         precision: 10, scale: 2, default: 0.0
    t.decimal  "transfer_fee",                            precision: 10, scale: 2, default: 0.0
  end

  create_table "tumblrs", force: :cascade do |t|
    t.integer  "user_id"
    t.boolean  "deleted"
    t.datetime "deleted_at"
    t.string   "uid"
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tutorials", id: :bigserial, force: :cascade do |t|
    t.integer  "user_id",               limit: 8
    t.integer  "profile_tutorial",      limit: 8
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "project_tutorial",      limit: 8
    t.integer  "profile_tutorial_prev", limit: 8
    t.integer  "project_tutorial_prev", limit: 8
    t.integer  "intro",                 limit: 8
    t.boolean  "facebook"
    t.boolean  "facebook_page"
    t.boolean  "setup_subscription"
  end

  create_table "twitches", force: :cascade do |t|
    t.integer  "user_id"
    t.boolean  "deleted"
    t.datetime "deleted_at"
    t.string   "uid"
    t.string   "name"
    t.string   "email"
    t.string   "nickname"
    t.string   "description"
    t.string   "image"
    t.string   "token"
    t.boolean  "expires"
    t.string   "display_name"
    t.string   "type"
    t.string   "bio"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "link_self"
    t.boolean  "partnered"
  end

  create_table "twitters", id: :bigserial, force: :cascade do |t|
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "user_id",         limit: 8
    t.text     "uid"
    t.text     "name"
    t.text     "image"
    t.text     "location"
    t.text     "description"
    t.text     "link"
    t.text     "oauth_token"
    t.text     "oauth_secret"
    t.text     "lang"
    t.integer  "followers_count", limit: 8
    t.text     "entities"
    t.text     "nickname"
  end

  create_table "updates", id: :bigserial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_suggestions", id: :bigserial, force: :cascade do |t|
    t.text     "term"
    t.integer  "popularity", limit: 8
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "user_venmos", id: :bigserial, force: :cascade do |t|
    t.text     "uid"
    t.text     "username"
    t.text     "email"
    t.text     "name"
    t.text     "first_name"
    t.text     "last_name"
    t.text     "image"
    t.text     "balance"
    t.text     "profile_url"
    t.text     "token"
    t.boolean  "expires"
    t.integer  "user_id",       limit: 8
    t.datetime "deleted_at"
    t.boolean  "deleted"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.text     "refresh_token"
    t.text     "expires_in"
    t.text     "phone"
  end

  create_table "users", id: :bigserial, force: :cascade do |t|
    t.text     "tagline",                                                       default: "Sits down at the fire of Ratatoskr"
    t.text     "fullname"
    t.text     "username"
    t.text     "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "password_digest"
    t.text     "remember_token"
    t.boolean  "admin"
    t.text     "website"
    t.text     "bio"
    t.integer  "goals_subscribers",           limit: 8,                         default: 256
    t.integer  "goals_monthly",               limit: 8,                         default: 7730
    t.integer  "goals_project",               limit: 8,                         default: 5
    t.text     "encrypted_password"
    t.text     "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",               limit: 8
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.text     "current_sign_in_ip"
    t.text     "last_sign_in_ip"
    t.text     "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.text     "unconfirmed_email"
    t.text     "provider"
    t.string   "uid"
    t.decimal  "subscription_amount",                   precision: 8, scale: 2, default: 0.0
    t.boolean  "subscription_status",                                           default: false
    t.text     "subscribed_permission"
    t.text     "subscriber_permission"
    t.boolean  "disabled",                                                      default: false
    t.datetime "deactivated_at"
    t.datetime "goals_updated_at"
    t.decimal  "subscribing_amount",                    precision: 8, scale: 2, default: 0.0
    t.boolean  "accept_message",                                                default: true
    t.text     "location"
    t.text     "bio_html"
    t.text     "direct_upload_url"
    t.boolean  "processed",                                                     default: false
    t.text     "subscription_status_initial"
    t.text     "legalname"
    t.boolean  "signup_during_subscription",                                    default: false
    t.text     "school"
    t.text     "concentration"
    t.boolean  "homepage_fundable"
    t.boolean  "fundable_show"
    t.integer  "goals_watching",              limit: 8,                         default: 10
    t.integer  "goals_reviews",               limit: 8,                         default: 10
    t.boolean  "post_to_facebook"
    t.boolean  "subscription_inactive"
    t.text     "default_billing_method"
    t.boolean  "subscription_switch",                                           default: true
    t.text     "memorized_fullname"
    t.integer  "homepage_fundable_weight",    limit: 8
    t.boolean  "explore_fundable"
    t.integer  "explore_fundable_weight",     limit: 8
    t.string   "firstname"
    t.string   "lastname"
    t.string   "preferred_name"
  end

  add_index "users", ["deactivated_at"], name: "idx_17362_index_users_on_deactivated_at", using: :btree

  create_table "video_images", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "majorpost_id"
    t.string   "audio_id"
    t.boolean  "deleted"
    t.datetime "deleted_at"
    t.string   "direct_upload_url"
    t.string   "uuid"
    t.string   "majorpost_uuid"
    t.string   "video_uuid"
    t.boolean  "skip_everafter"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "videos", id: :bigserial, force: :cascade do |t|
    t.text     "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "majorpost_id",                limit: 8
    t.text     "external"
    t.boolean  "youtube_vimeo"
    t.integer  "project_id",                  limit: 8
    t.text     "thumbnail_file_name"
    t.text     "thumbnail_content_type"
    t.integer  "thumbnail_file_size",         limit: 8
    t.datetime "thumbnail_updated_at"
    t.text     "video_file_name"
    t.text     "video_content_type"
    t.integer  "video_file_size",             limit: 8
    t.datetime "video_updated_at"
    t.text     "job_id"
    t.text     "encoded_state",                         default: "unencoded"
    t.text     "output_url"
    t.integer  "duration_in_ms",              limit: 8
    t.text     "aspect_ratio"
    t.text     "content_temp"
    t.text     "tags_temp"
    t.integer  "archive_id",                  limit: 8
    t.text     "thumbnail"
    t.boolean  "processed",                             default: false,       null: false
    t.integer  "user_id",                     limit: 8,                       null: false
    t.string   "direct_upload_url"
    t.text     "output_url_mp4"
    t.boolean  "skip_everafter",                        default: false
    t.integer  "subscribed_id",               limit: 8
    t.integer  "patron_video_id",             limit: 8
    t.integer  "organization_id",             limit: 8
    t.integer  "organization_application_id", limit: 8
    t.string   "majorpost_uuid"
    t.string   "uuid"
  end

  add_index "videos", ["processed"], name: "idx_17408_index_videos_on_processed", using: :btree
  add_index "videos", ["user_id"], name: "idx_17408_index_videos_on_user_id", using: :btree

  create_table "vimeos", id: :bigserial, force: :cascade do |t|
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "user_id",      limit: 8
    t.text     "oauth_token"
    t.text     "oauth_secret"
    t.text     "link"
    t.text     "nickname"
    t.text     "uid"
    t.text     "name"
    t.text     "description"
    t.text     "image"
  end

  create_table "votes", id: :bigserial, force: :cascade do |t|
    t.integer  "votable_id",   limit: 8
    t.text     "votable_type"
    t.integer  "voter_id",     limit: 8
    t.text     "voter_type"
    t.boolean  "vote_flag"
    t.text     "vote_scope"
    t.integer  "vote_weight",  limit: 8
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "votes", ["votable_id", "votable_type", "vote_scope"], name: "idx_17429_index_votes_on_votable_id_and_votable_type_and_vote_s", using: :btree
  add_index "votes", ["votable_id", "votable_type"], name: "idx_17429_index_votes_on_votable_id_and_votable_type", using: :btree
  add_index "votes", ["voter_id", "voter_type", "vote_scope"], name: "idx_17429_index_votes_on_voter_id_and_voter_type_and_vote_scope", using: :btree
  add_index "votes", ["voter_id", "voter_type"], name: "idx_17429_index_votes_on_voter_id_and_voter_type", using: :btree

  create_table "watcheds", id: :bigserial, force: :cascade do |t|
    t.integer  "project_id", limit: 8
    t.integer  "user_id",    limit: 8
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "watcher_id", limit: 8
  end

  create_table "youtubes", force: :cascade do |t|
    t.integer  "user_id"
    t.boolean  "deleted"
    t.datetime "deleted_at"
    t.string   "uid"
    t.string   "name"
    t.string   "email"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "image"
    t.string   "token"
    t.string   "refresh_token"
    t.string   "expires_at"
    t.boolean  "expires"
    t.string   "sub"
    t.boolean  "email_verified"
    t.string   "given_name"
    t.string   "profile"
    t.string   "picture"
    t.string   "gender"
    t.string   "birthday"
    t.string   "locale"
    t.string   "hd"
    t.string   "iss"
    t.string   "at_hash"
    t.string   "id_info_sub"
    t.string   "azp"
    t.string   "aud"
    t.string   "iat"
    t.string   "exp"
    t.string   "openid_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_foreign_key "mailboxer_conversation_opt_outs", "mailboxer_conversations", column: "conversation_id", name: "mb_opt_outs_on_conversations_id", on_update: :restrict, on_delete: :restrict
  add_foreign_key "mailboxer_notifications", "mailboxer_conversations", column: "conversation_id", name: "notifications_on_conversation_id", on_update: :restrict, on_delete: :restrict
  add_foreign_key "mailboxer_receipts", "mailboxer_notifications", column: "notification_id", name: "receipts_on_notification_id", on_update: :restrict, on_delete: :restrict
end
