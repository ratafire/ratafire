Ratafire::Application.routes.draw do



  post '/rate' => 'rater#create', :as => 'rate'

#------Gems------

#---Mathjax---
	mathjax 'mathjax'

#---Activities--- 
	get "activities/index"

#---Devise---    
	devise_for :users, :controllers => { :invitations => 'users/invitations', :omniauth_callbacks => "users/omniauth_callbacks",:registrations => "registrations" }
	match "/signup" => "devise/registrations#new"
	get "users/new"  
	#Facebook Signup
	match ':uuid/signup/with/facebook', to: 'facebooks#facebook_signup', as: :facebook_signup
	match ':uuid/signup_update/with/facebook', to: 'users#facebook_update', as: :facebook_update
	match'/mobile_sign_in', to: 'static_pages#mobile_sign_in', as: :mobile_sign_in

#---Redactor---    
	mount RedactorRails::Engine => '/redactor_rails'

#---Resque---     


  authenticate :user, lambda {|u| u.admin == true } do
    mount Resque::Server, :at => "/resque"
  end

#---Message---     

#---Home Page---
	root to: 'static_pages#home'

#---Static Pages---
	match '/terms', to: 'static_pages#terms', as: :terms
	match '/privacy', to: 'static_pages#privacy', as: :privacy
	match '/guidelines', to: 'static_pages#guidelines', as: :guidelines
	match '/pricing', to: 'static_pages#pricing', as: :pricing
	match '/faq', to: 'static_pages#faq', as: :faq
	match '/about', to: 'static_pages#about'
	match '/contact', to: 'static_pages#contact'
	match '/discovered', to: 'static_pages#discovered', as: :discovered_path
	match'/mobile_about', to: 'static_pages#mobile_about', as: :mobile_about

#---Projects Matches---
	match ':user_id/:id/about', to: 'projects#about', as: :project_about
	match ':user_id/:id/contributors', to: 'projects#contributors', as: :project_contributors
	match ':user_id/:id/mplist', to: 'projects#mplist', as: :project_mplist
	match ':user_id/:id/settings', to: 'projects#settings', as: :project_settings
	match ':user_id/:id/archive', to: 'archives#archive', as: :project_archives
	match ':user_id/:id/archive/videos', to: 'archives#videos', as: :project_archive_videos
	match ':user_id/:id/archive/artwork', to: 'archives#artwork', as: :project_archive_artwork
	match ':user_id/projects/:id/realm', to: 'projects#realm',as: :project_realms
	match ':user_id/projects/:id/update_title_and_tagline', to: 'projects#update_title_and_tagline', as: :project_update_title_and_tagline

	match ':user_id/:id', to: 'projects#show', as: :user_project
	match ':user_id/r/project/newproject', to: 'projects#create', via: :post, as: :new_project
	match ':user_id/projects/:id', to: 'projects#update', via: :put, as: :project_update
	match ':user_id/projects/:id', to: 'projects#destroy', via: :delete, as: :throw_draft

	match ':user_id/projects/:project_id/assigned_projects/:id', to: 'assigned_projects#destroy', via: :delete, as: :delete_assigned_project

	#Inspirations
	match ':user_id/projects/:project_id/p_u_inspirations/:id', to: 'pu_inspirations#destroy', via: :delete, as: :delete_p_u
	match ':user_id/projects/:project_id/p_p_inspirations/:id', to: 'pp_inspirations#destroy', via: :delete, as: :delete_p_p
	match ':user_id/projects/:project_id/p_m_inspirations/:id', to: 'pm_inspirations#destroy', via: :delete, as: :delete_p_m
	match ':user_id/projects/:project_id/p_e_inspirations/:id', to: 'pe_inspirations#destroy', via: :delete, as: :delete_p_e

	#Completion
	match ':user_id/projects/:id/you-completed-me', to: 'archives#complete',via: :get, as: :you_completed_me

	#Abandon
	match ':user_id/projects/:id/2/you-shall-not-pass', to: 'projects#abandon', via: :get,as: :you_shall_not_pass
	match ':user_id/projects/:id/2/i-will-be-back', to: 'projects#reopen', as: :i_will_be_back

	#Early Access
	match ':user_id/projects/:id/you-can-be-there-now', to: 'projects#early_access_turnon', as: :project_early_access_turnon
	match ':user_id/projects/:id/you-cannnot-see-it-now', to: 'projects#early_access_turnoff', as: :project_early_access_turnoff

	#Recommanders
	match ':user_id/:id/r/recommanders', to: 'projects#recommanders', as: :project_recommanders

	#Watchers
	match 'watch/project/-/:project_id/:user_id', to: 'watcheds#project', as: :watch_project
	match 'unwatch/project/-/:project_id/:user_id', to: 'watcheds#unwatch_project',as: :unwatch_project
	match ':user_id/:id/r/watchers', to: 'projects#watchers', as: :project_watchers

#---Majorposts Matches---
	match ':user_id/:project_id/:id', to: 'majorposts#show', as: :user_project_majorpost
	match ':user_id/projects/:project_id/majorposts/:id', to: 'majorposts#destroy', via: :delete, as: :majorpost_delete
	match ':user_id/:id/r/newmajorpost', to: 'majorposts#create',via: :post, as: :new_majorpost
	match ':user_id/projects/:project_id/majorposts/:id', to: 'majorposts#update', via: :put, as: :majorpost_update
	match ':user_id/majorpost/:id/update_title_and_tagline', to: 'majorposts#update_title_and_tagline', as: :majorpost_update_title_and_tagline
	match ':user_id/projects/:project_id/majorposts/:id', to: 'majorposts#destroy', via: :delete, as: :throw_majorpost_draft

	#Inspirations
	match ':user_id/projects/:project_id/majorposts/:majorpost_id/m_u_inspirations/:id', to: 'mu_inspirations#destroy', via: :delete, as: :delete_m_u
	match ':user_id/projects/:project_id/majorposts/:majorpost_id/m_p_inspirations/:id', to: 'mp_inspirations#destroy', via: :delete, as: :delete_m_p
	match ':user_id/projects/:project_id/majorposts/:majorpost_id/m_m_inspirations/:id', to: 'mm_inspirations#destroy', via: :delete, as: :delete_m_m
	match ':user_id/projects/:project_id/majorposts/:majorpost_id/m_e_inspirations/:id', to: 'me_inspirations#destroy', via: :delete, as: :delete_m_e

	#Ajax get chapters
	match ':user_id/projects/:project_id/majorposts/:id/chapter', to: 'majorposts#chapter', as: :get_chapter  

#---Archive Matches---

	match ':user_id/:project_id/archive/:id', to: 'archives#show', as: :user_project_archive
	match ':user_id/:project_id/archive/:id/about', to: 'archives#about_show', as: :user_project_archive_about
	#Ajax get chapters
	match ':user_id/projects/:project_id/archives/:id/chapter', to: 'archives#chapter', as: :get_archive_chapter

#---User Pages Matches---

	match ':id/r/projects/list', to: 'users#projects', as: :projects
	match ':id/r/projects_past/list', to: 'users#projects_past', as: :projects_past
	match ':id/r/r/updatefeed', to: 'users#update_feed', as: :user_update_feed

	match ':id/r/settings/goals', to: 'users#goals', as: :goals
	match ':id/r/settings/profile', to: 'users#edit', as: :edit_user
	match ':id/r/settings/profile#bio-edit', to: 'users#edit', as: :edit_bio
	match ':id/r/settings/profile#social-media', to: 'users#edit', as: :edit_socialmedia
	match ':id/r/settings/profile#facebook-sync', to: 'users#edit', as: :edit_facebook_sync
	match ':id/r/settings/subscription', to: 'subscriptions#settings', as: :subscription_settings
	match ':id/r/settings/transactions', to: 'subscriptions#transactions', as: :subscription_transactions
	match ':id/r/settings/profilephoto/delete', to: 'users#profile_photo_delete', via: :delete, as: :photo_delete
	match ':id/r/users/disable/user', to: 'users#disable', via: :post, as: :disable_user

	match ':id/upload/profile/photo', to: 'users#create_profilephoto', via: :post, as: :create_profilephoto
	match ':id/upload/profile/photosettings', to: 'users#create_profilephoto_settings', via: :post, as: :create_profilephoto_settings

	match ':user_id/activities/delete/:id', to: 'activities#destroy', via: :delete, as: :activity_delete

#---Video Upload---
	match ':user_id/upload/video/:project_id/this_is_a_secret_path_to_a_strange_land', :to => "videos#create_project_video", via: :post, as: :create_project_video
	match ':user_id/upload/video/:project_id/:majorpost_id/whose_midnight_revels_by_a_forest_side', :to => "videos#create_majorpost_video", via: :post, as: :create_majorpost_video
	match '/add_external_video', to: 'videos#add_external_video', via: :post, as: :add_external_video
	match ":user_id/projects/:project_id/videos/:id", :to => "videos#destroy", via: :delete, as: :project_video_delete
	match "/videos/notification/r/encode_notify", :to => "videos#encode_notify"
	match 'video_upload/simple_destroy/yesterday_once_more/r/:id', :to => 'videos#simple_destroy', via: :delete, as: :video_simple_destroy

#---Artwork---
	match ':user_id/upload/artwork/:project_id/invoke_thy_aid_to_my_adventrous_song', :to => "artworks#create_project_artwork", via: :post, as: :create_project_artwork
	match ':user_id/upload/artwork/:project_id/:majorpost_id/of_some_great_ammiral_were_but_a_wand', :to => "artworks#create_majorpost_artwork", via: :post, as: :create_majorpost_artwork
	match ":user_id/:project_id/artworks/delete/:id", to: 'artworks#destroy', via: :delete, as: :artwork_delete
	match ':user_id/projects/:project_id/artworks/:id', to: 'artworks#download', :controller => "artworks",:action => 'download', :conditions => { :method => :get }, as: :artwork_download

#---Audio---

	match ':user_id/upload/audio/:project_id/it_is_a_song_that_goes_on_forever', :to => "audios#create_project_audio", via: :post, as: :create_project_audio
	match ":user_id/:project_id/audio/delete/:id", to: 'audios#destroy', via: :delete, as: :audio_delete
	match ':user_id/audio/:project_id/:majorpost_id/you_shall_not_pass', :to => "audios#create_majorpost_audio", via: :post, as: :create_majorpost_audio
	match 'add_external_audio', :to => "audios#add_external_audio", via: :post,as: :add_external_audio

#---PDF---

	match ':user_id/upload/pdf/:project_id/little_crab', :to => "pdfs#create_project_pdf", via: :post, as: :create_project_pdf
	match ':user_id/:project_id/pdf/delete/:id', to: 'pdfs#destroy', via: :delete, as: :pdf_delete
	match ':user_id/projects/:project_id/pdf/:id', to: 'pdfs#download', :controller => "pdfs",:action => 'download', :conditions => { :method => :get }, as: :pdf_download
	match ':user_id/pdf/:project_id/:majorpost_id/you_shall_not_pass', :to => "pdfs#create_majorpost_pdf", via: :post, as: :create_majorpost_pdf

#---Icon ---
	match ':user_id/upload/icon/:project_id/invoke_thy_aid_to_my_adventrous_song', :to => "icons#create_project_icon", via: :post, as: :create_project_icon
	match ':user_id/projects/:project_id/icons/:id', to: 'icons#destroy', via: :delete, as: :icon_delete

#---Social Meida---
	match ':user_id/:provider/disconnect/farewell', to: 'users#disconnect', as: :disconnect
	match 'auth/failure', to: redirect('/')

#---Bifrost----
	match ':user_id/r/bifrost/heimdall-open-it/', to: 'bifrosts#create', via: :post, as: :call_heimdall

#---iBifrost---for adding contributors to projects
	match ':user_id/r/ibifrost/heimdall-can-you-hear-me/', to: 'ibifrosts#create', via: :post, as: :heimdall_open 
	match ':user_id/projects/:project_id/inviteds/:id', to: 'inviteds#destroy', via: :delete, as: :heimdall_close 

#---Subscriptions---
	match ':id/r/cloud_patronage/patrons', to: 'subscriptions#subscribers', as: :subscribers  
	match ':id/r/cloud_patronage/patron_of', to: 'subscriptions#subscribing', as: :subscribing
	match ':id/r/subscriptions/remove/:subscriber_id', to: 'subscriptions#destroy', via: :delete, as: :remove_subscriber
	match ':id/r/subscriptions/unsubscribe/:subscribed_id', to: 'subscriptions#unsub', via: :delete, as: :unsubscribe
	match ':id/r/cloud_patronage/past_patrons', to: 'subscriptions#subscribers_past', as: :subscribers_past
	match ':id/r/cloud_patronage/past_patron_of', to: 'subscriptions#subscribing_past', as: :subscribing_past

	match ':id/r/subscriptions/subscription_on', to: 'subscriptions#turnon', as: :subscription_turnon
	match ':id/r/subscriptions/subscription_off', to: 'subscriptions#turnoff', as: :subscription_turnoff

	#Amazon Payments
	match ':id/r/subscriptions/amazon_payments_connect', to: 'amazon#pre_create_recipient', as: :connect_to_amazon_payments
	match 'r/subscriptions/amazon_payments/recipient/postfill', to: 'amazon#post_create_recipient', :via => [:get, :post]
	match ':id/subscriptions/amazon_payments/recipient/cancel', to: 'amazon#cancel_recipient', via: :get, as: :cancel_recipient
	match ':id/subscriptions/amazon_payments/recipient/reconnect', to: 'amazon#reconnect_recipient', as: :reconnect_recipient
	match 'r/subscriptions/amazon_payments/subscribe/post_subscribe', to: 'amazon#post_subscribe', :via => [:get, :post]

	#Amazon Login and Pay
	match 'r/subscriptions/amazon_login_and_pay/recipient/postfill', to: 'amazon_lap#post_create_seller', :via => [:get, :post]

	#Stripe
	match ':id/r/stripe/add_a_card', to: 'charges#add_a_card', as: :add_a_card
	match ':id/r/stripe/remove_a_card', to: 'charges#remove_a_card', as: :remove_a_card
	match ':id/:application_id/r/stripe/add_a_recipient', to: 'charges#add_a_recipient', as: :add_a_recipient
	match ':id/r/stripe/update_recipient', to: 'charges#update_recipient', as: :update_recipient
	match ':id/r/stripe/add_card_subscribe', to: 'charges#add_card_subscribe', as: :add_card_subscribe
	match ':id/r/stripe/with_card_subscribe', to: 'charges#with_card_subscribe', as: :with_card_subscribe
	match ':subscription_id/r/subscription/thank_you', to: 'charges#subscription_thank_you', as: :subscription_thank_you

	#Paypal
	match '/:id/r/paypal/create_billing_agreement', to: 'payments#create_billing_agreement', as: :create_billing_agreement
	match '/paypal_agreement_success', to: 'payments#billing_agreement_success'
	match '/paypal_agreement_cancel', to: 'payments#billing_agreement_cancel'
	match '/:id/r/paypal/remove_billing_agreement', to: 'payments#remove_billing_agreement', as: :remove_billing_agreement
	match '/:subscription_id/r/paypal/add_paypal_subscribe_success', to: 'charges#add_paypal_subscribe'
	match '/:subscription_id/r/paypal/add_paypal_subscribe_failed', to: 'charges#add_paypal_subscribe_failed'

	#Venmo
	match '/venmo_after_auth/r/r/:subscriber_id/:subscribed_id/:amount/', to: 'charges#add_venmo_subscribe', as: :add_venmo_subscribe

	#Payment Settings
	match '/:id/r/settings/payment', to: "subscriptions#payment_settings", as: :payment_settings

	#Transactions
	match 'r/subscriptions/transactions/:id/receiving_transactions', to: 'subscriptions#receiving_transactions', as: :receiving_transactions
	match 'r/subscriptions/transactions/:id/paying_transactions', to: 'subscriptions#paying_transactions', as: :paying_transactions
	match '/:id/r/settings/transactions/:transaction_id', to: 'subscriptions#transaction_details', as: :transaction_details
	match '/:id/r/settings/transactions/:transaction_id/refund', to: 'subscriptions#refund', as: :refund

	#Supporters
	match ':id/r/supports/supporters', to: 'supports#supporters', as: :supporters
	match ':id/r/supports/supporting', to: 'supports#supporting', as: :supporting
	match ':id/r/supports/remove/:subscriber_id', to: 'supports#destroy', via: :delete, as: :remove_supporter
	match ':id/r/supports/unsupport/:subscribed_id', to: 'supports#unsub', via: :delete, as: :unsupport
	match ':id/r/supports/supporters_past', to: 'supports#supporters_past', as: :supporters_past
	match ':id/r/supports/supporting_past', to: 'supports#supporting_past', as: :supporting_past

	#Setup
	match ':id/:subscription_application_id/r/update/subscription', to: 'subscription_applications#updates', as: :update_subscription_application
	match ':id/r/setup/subscription', to: 'subscription_applications#setup', as: :setup_subscription
	match ':id/r/goals/subscription', to: 'subscription_applications#goals', as: :goals_subscription
	match ':id/:subscription_application_id/project/subscription', to: 'subscription_applications#project', as: :project_subscription
	match ':id/:subscription_application_id/discussion/subscription', to: 'subscription_applications#discussion', as: :discussion_subscription
	match ':id/:subscription_application_id/payments/subscription', to: 'subscription_applications#payments', as: :payments_subscription
	match ':id/:subscription_application_id/identification/subscription', to: 'subscription_applications#identification', as: :identification_subscription
	match ':id/:subscription_application_id/apply/subscription', to: 'subscription_applications#apply', as: :apply_subscription
	match ':id/:subscription_application_id/pending/subscription', to: 'tutorials#subscription', as: :pending_subscription
	match ':id/:subscription_application_id/video/subscription', to: 'subscription_applications#video', as: :video_subscription
	match ':id/:subscription_application_id/subscription_video_upload/subscription', to: 'subscription_applications#subscription_video_upload', as: :subscription_video_upload

	#Video
	match ':id/r/add_patron_video/add', to: 'patron_videos#upload_patron_video', as: :upload_patron_video

#---Payments---
	match ':id/r/r/subscription/', to:'subscriptions#why', as: :why
	match ':id/:default/:amount/r/payments/subscribe', to: 'subscriptions#new', as: :subscribe
	match ':id/r/payments/checkout_amazon', to: 'subscriptions#amazon', as: :amazon
	match ':id/r/payments/subscription/create', to: 'subscriptions#create',via: :post, as: :create_subscription

#---Updates---
	match ':id/r/interesting/homepage', to: 'updates#interesting', as: :interesting_homepage
	match ':id/r/subscribing/update', to: 'updates#subscribing_update', as: :subscribing_update 
	match ':id/r/followed_tags/update', to: 'updates#followed_tags', as: :followed_tags 
	match ':id/r/liked/update', to: 'updates#liked', as: :liked
	match ':id/r/watched/update', to: 'updates#watched', as: :watched

	match '/search', to: 'updates#search', as: :search

	match '/staffpicks', to: 'updates#featured', as: :featured
	match '/all', to: 'updates#all', as: :all
	match '/art', to: 'updates#art', as: :art
	match '/music', to: 'updates#music', as: :music
	match '/games', to: 'updates#games', as: :games
	match '/writing', to: 'updates#writing', as: :writing
	match '/videos', to: 'updates#videos', as: :videos
	match '/math', to: 'updates#math', as: :math
	match '/science', to: 'updates#science', as: :science
	match '/humanity', to: 'updates#humanity', as: :humanity
	match '/engineering', to: 'updates#engineering', as: :engineering
	match '/fundable', to: 'updates#fundable', as: :fundable
	match '/genius', to: 'updates#genius', as: :genius
	match '/challenges', to: 'updates#challenges', as: :challenges

	match '/r/realms/veryseriously/more/:realm', to: 'updates#realm_selector', as: :realm_selector

	match '/test', to: "updates#test", as: :test

#---Tags---
	match 'tags/-/-/:tag', to: 'updates#tags', as: :tag 
	match 'tags/follow_tag/:user_id/:tag_id', to: 'tag_relationships#follow', as: :follow_tag 
	match 'tags/unfollow_tag/:user_id/:tag_id', to: 'tag_relationships#destroy', as: :unfollow_tag
	match 'tags/-/-/:tag/followers', to: 'updates#tag_followers', as: :tag_followers

#---Like---
	match 'like/project/-/:project_id/:user_id', to: 'likes#project', as: :like_project
	match 'like/majorpost/-/:majorpost_id/:user_id', to: 'likes#majorpost', as: :like_majorpost
	match 'like/comment/-/:comment_id/:user_id', to: 'likes#comment', as: :like_comment
	match 'like/project_comment/-/:project_comment_id/:user_id', to: 'likes#project_comment', as: :like_project_comment

	match 'unlike/project/-/:project_id/:user_id', to: 'likes#unlike_project',as: :unlike_project
	match 'unlike/majorpost/-/:majorpost_id/:user_id', to: 'likes#unlike_majorpost', as: :unlike_majorpost
	match 'unlike/comment/-/:comment_id/:user_id', to: 'likes#unlike_comment', as: :unlike_comment
	match 'unlike/project_comment/-/:project_comment_id/:user_id', to: 'likes#unlike_project_comment', as: :unlike_project_comment

#---Beta---
	match '/beta', to: 'beta_users#new', as: :beta
	match '/beta/user/beta/beta/betainvite', to: 'beta_users#create', via: :post,as: :beta_create
	match '/beta_status', to: 'beta_users#status', as: :beta_status

#---Admin---
	#Beta
	match '/beta_admin', to: 'beta_users#show', as: :beta_admin
	match '/beta_applied_users', to: 'beta_users#applied_users', as: :admin_applied_users
	match '/beta_approved_users', to: 'beta_users#approved_users', as: :admin_approved_users
	match '/beta_ignored_users', to: 'beta_users#ignored_users', as: :admin_ignored_users
	match '/test_admin', to: 'admin#test', as: :admin_test
	match '/content_admin', to: 'admin#content', as: :admin_content
	match '/content_project_admin', to: 'admin#content_project', as: :admin_content_project
	match '/content_majorpost_admin', to: 'admin#content_majorpost', as: :admin_content_majorpost
	match '/content_deleted_project_admin', to: 'admin#content_deleted_project', as: :admin_content_deleted_project
	match '/content_deleted_majorpost_admin', to: 'admin#content_deleted_majorpost', as: :admin_content_deleted_majorpost
	match '/content_deleted_comment_admin', to: 'admin#content_deleted_comment', as: :admin_content_deleted_comment
	match '/content_deleted_project_comment_admin', to: 'admin#content_deleted_project_comment', as: :admin_content_deleted_project_comment
	match '/test_projects_admin', to: 'admin#test_projects', as: :admin_test_projects
	match '/test_majorposts_admin', to: 'admin#test_majorposts', as: :admin_test_majorposts  
	match '/pending_discussions_admin', to: 'admin#pending_discussions', as: :admin_pending_discussions
	match '/patron_video_admin', to: 'admin#patron_video', as: :admin_patron_video

	#Discussion
	match '/discussion_admin', to: "admin#discussion", as: :admin_discussion
	match '/discussion/review/r/:id', to: "admin#discussion_review", as: :admin_discussion_review
	match '/discussion/review/update/:id', to: "admin#discussion_review_update", as: :admin_discussion_review_update
	match '/discussion/:id/update_title_and_tagline/update', to: 'discussions#update_title_and_tagline', as: :discussions_update_title_and_tagline

	match '/:id/r/ratafire/welcome-new-friend/beta_approve', to: 'beta_users#approve',as: :beta_approve
	match '/:id/r/ratafire/welcome-new-friend/beta_ignore', to: 'beta_users#ignore', as: :beta_ignore

	#Subscription
	match '/subscription_admin', to: 'admin#subscription', as: :admin_subscription
	match '/pending_subscriptions_admin', to: 'admin#pending_subscription_applications', as: :admin_pending_subscription_applications
	match '/subscription/review/r/:id', to: 'admin#subscription_applications_review', as: :admin_subscription_applications_review
	match '/subscription/review/update/:id', to: 'admin#subscription_application_review_update', as: :admin_subscription_review_update

	match '/post_staff_pick', to: 'admin#staff_pick', via: :post
	match '/this_project/is_not/good_enough/:project_id', to: 'admin#project_staff_picks_delete', as: :project_staff_picks_delete
	match '/this_majorpost/is_not/good_enough/:majorpost_id', to: 'admin#majorpost_staff_picks_delete', as: :majorpost_staff_picks_delete
	match '/delete_content', to: 'admin#delete_content', via: :post
	match '/restore_content/i_will_be_back/live_to_fight_another_day/arise/:type/:id', to: 'admin#restore', as: :restore
	match '/add_tests', to: 'admin#add_tests', via: :post
	match '/untest_content/this_is_a_real_thing/let_me_come_back/i_am_serious/:type/:id', to: 'admin#untest', as: :untest

	match '/admin', to: 'admin#main', as: :admin

	match '/admin_user', to: 'admin#users', as: :admin_users
	match '/content_admin_user', to: 'admin#content_users', as: :admin_content_users

	#Patron Videos

	match '/patron_videos/review/r/:id', to: 'patron_videos#patron_videos_review', as: :admin_patron_videos_review
	match '/patron_videos/review/update/:id', to: 'patron_videos#patron_videos_update', as: :admin_patron_videos_update
	match '/patron_videos/display/in/theworld', to: 'patron_videos#pending_patron_videos', as: :admin_pending_patron_videos

	#Admin Action
	match '/admin_action/:type/:id/:actionname/you-shall-not-pass/seriously/',to: "admin#admin_actions", as: :admin_actions
	match '/admin_action/:type/:id/:realmname/i-will-add-realm/seriously/',to: "admin#add_admin_realm", as: :admin_add_realm

#---Tests--- 
	match '/test_resque', to: 'admin#test_resque', as: :test_resque 

#---Messaging---
	match '/messaging/:id/r/inbox', to: 'messages#inbox', as: :messaging_inbox	
	match '/messaging/:id/conversation/:conversation_id/', to:'messages#show', as: :messaging_show
	match '/messaging/:id/r/sent', to:'messages#sent', as: :messaging_sent
	match '/messaging/:id/r/trash', to:'messages#trash', as: :messaging_trash
	match '/messaging/:id/r/settings', to: 'messages#settings', as: :messaging_settings
	match '/messaging/:id/r/create', to: 'messages#create', as: :messaging_create
	match '/messaging/:id/r/trash_message_box/:conversation_id', to: 'messages#trash_message_box', :via => [:get, :post], as: :messaging_trash_message_box
	match '/messaging/:id/r/restore/:conversation_id', to: 'messages#restore', :via => [:get, :post], as: :messaging_restore
	match '/messaging/:id/r/trash_forever/:conversation_id', to: 'messages#trash_forever', :via => [:get, :post], as: :messaging_trash_forever
	match '/messaging/:id/r/blacklist', to: 'messages#blacklist', as: :messaging_blacklist
	match '/messaging/:id/r/unblock/:blacklisted_id', to: "messages#unblock", as: :messaging_unblock
	match '/messaging/:id/r/on', to: 'messages#turnon', as: :messaging_turnon
	match '/messaging/:id/r/off', to: 'messages#turnoff', as: :messaging_turnoff

#---Blog---
	match '/blog', to: 'blogposts#show', as: :blog
	match '/blogselect', to: 'blogposts#select', as: :admin_blog
	match '/blog/category/:category/create', to: 'blogposts#create', as: :blog_post_create
	match '/blog/category/:category/:id', to: 'blogposts#single', as: :blog_post
	match '/blog/category/:category/:id/edit', to: 'blogposts#edit', as: :edit_blog_post
	match '/blog/category/:category/:id/delete', to:'blogposts#delete', as: :delete_blog_post
	match '/blog/category/:category/:id/update', to: 'blogposts#update', as: :update_blog_post
	match '/blog-new-features', to: 'blogposts#new_features', as: :blog_new_features
	match '/blog-engineering', to: 'blogposts#engineering', as: :blog_engineering
	match '/blog-design', to: 'blogposts#design', as: :blog_design
	match '/blog-news', to: 'blogposts#news', as: :blog_news
	match '/blog/category-selector/r/r/r/r/:category', to: 'blogposts#category_selector', as: :blog_category_selector

#---Tutorial---	

	match '/:id/user/user_profile/new/tutorial/step1', to: 'tutorials#profile_tutorial_step1', as: :profile_tutorial_step1
	match '/:id/user/user_profile/new/tutorial/step2', to: 'tutorials#profile_tutorial_step2', as: :profile_tutorial_step2
	match '/:id/user/user_profile/new/tutorial/step3', to: 'tutorials#profile_tutorial_step3', as: :profile_tutorial_step3	
	match '/:id/user/user_profile/new/tutorial/step4', to: 'tutorials#profile_tutorial_step4', as: :profile_tutorial_step4

	match '/:id/user/user_project/new/tutorial/step1', to: 'tutorials#project_tutorial_step1', as: :project_tutorial_step1
	match '/:id/user/user_project/new/tutorial/step2', to: 'tutorials#project_tutorial_step2', as: :project_tutorial_step2
	match '/:id/user/user_project/new/tutorial/step3', to: 'tutorials#project_tutorial_step3', as: :project_tutorial_step3

	#Intro
	match '/user/user_intro/tutorial/new_world/:id/', to: "tutorials#intro", as: :intro_tutorial
	match '/:id/user/user_intro/new/tutorial/start_using', to: "tutorials#after_intro", as: :after_intro_tutorial

	#Messages
	match ':id/user_message/tutorial/facebook_page', to: "tutorials#add_facebook_pages", as: :add_facebook_pages_tutorial

#---Help---
	match '/help', to: 'helps#show', as: :help

	#Projects
	match '/help_how_do_I_start_a_project', to: 'helps#how_do_I_start_a_project', as: :how_do_I_start_a_project
	match '/help_what_are_major_posts', to: 'helps#what_are_major_posts', as: :what_are_major_posts
	match '/help_how_do_I_add_inspirations', to: 'helps#how_do_I_add_inspirations', as: :how_do_I_add_inspirations
	match '/help_how_do_I_embed_code', to: 'helps#how_do_I_embed_code', as: :how_do_I_embed_code
	match '/help_how_do_I_insert_equations', to: 'helps#how_do_I_insert_equations', as: :how_do_I_insert_equations
	match '/help_how_do_I_upload_or_embed_a_video', to: 'helps#how_do_I_upload_or_embed_a_video', as: :how_do_I_upload_or_embed_a_video
	match '/help_how_do_I_upload_an_artwork', to: 'helps#how_do_I_upload_an_artwork', as: :how_do_I_upload_an_artwork
	match '/help_what_is_early_access', to: 'helps#what_is_early_access', as: :what_is_early_access

	#Subscription
	match '/help_how_do_I_setup_subscription', to: 'helps#how_do_I_setup_subscription', as: :how_do_I_setup_subscription
	match '/help_how_do_I_subscribe_to_another_user', to: 'helps#how_do_I_subscribe_to_another_user', as: :how_do_I_subscribe_to_another_user
	match '/help_how_do_I_check_transactions', to: 'helps#how_do_I_check_transactions', as: :how_do_I_check_transactions

	#Social
	match '/help_look_around', to: 'helps#look_around', as: :look_around
	match '/help_what_are_the_goals_on_my_profile_page', to: 'helps#what_are_the_goals_on_my_profile_page', as: :what_are_the_goals_on_my_profile_page

#---Discussion---

	#Discussion
	match '/:user_id/r/discussion/newdiscussion', to: "discussions#create", via: :post, as: :new_discussion
	match '/:id/r/discussion/select_a_realm', to: "discussions#realm", as: :discussion_realms
	match '/:id/r/discussion/update', to: "discussions#update", as: :discussion_update
	match '/:id/r/discussion/subrealm', to: "discussions#subrealm", as: :discussion_subrealm
	match '/:id/r/discussion/edit', to: "discussions#edit", as: :discussion_edit
	match '/:id/r/discussion/throw', to: "discussions#destroy", as: :throw_discussion	
	match '/:id/r/discussion/show', to: "discussions#show", as: :show_discussion

	#Discussion Threads
	match '/create/r/discussion_thread/create', to: "discussion_threads#create", as: :discussion_thread_create	
	match '/:id/r/discussion_thread/show', to: "discussion_threads#show", as: :discussion_thread_show	
	match '/:id/r/discussion_thread/destroy', to: "discussion_threads#destroy", as: :discussioin_thread_destroy

#---Project Rating---

	match '/project_rating', to: 'ratings#create', as: :ratings
	match '/post_to_rating', to: 'ratings#letsrate', as: :post_to_rating
	match '/:id/:project_id/r/review', to: 'project_comments#new', as: :new_project_review

	#upvote and downvote
	match '/:id/:project_comment_id/upvote/r', to: 'project_comments#upvote', as: :upvote
	match '/:id/:project_comment_id/downvote/r', to: 'project_comments#downvote', as: :downvote

#---Facebook Update---
	
	#callback url
	match '/facebook_update_callback_kingsman', to: 'facebook_updates#receive'
	match '/:user_id/:page_id/r/facebook_sync', to: 'facebookpages#sync', as: :facebookpage_sync
	match '/:user_id/:page_id/r/facebook_unsync', to: 'facebookpages#unsync', as: :facebookpage_unsync
	match ':id/facebook_update/manners_maketh_men/delete', to: 'facebookupdates#delete', as: :facebookupdate_delete

#---Organizations---	

	match '/organizations', to: 'organizations#intro', as: :organizations_intro
	match '/organization_application/r/basic_info/:id/', to: 'organization_applications#basic_info', as: :basic_info_organization_application
	match '/organization_application/r/video/:id/:organization_application_id', to: 'organization_applications#video', as: :video_organization_application
	match '/organization_application/r/payments/:id/:organization_application_id', to: 'organization_applications#payments', as: :payments_organization_application
	match '/organization_application/r/updates/:id/:organization_application_id', to: 'organization_applications#updates', :via => [:put,:post], as: :organization_applications_update
	match '/organization_application/r/video_upload/:id/:organization_application_id', to: 'organization_applications#organization_video_upload', as: :organization_application_video_upload
	match '/organization_application/r/cancel_organization_application/:id/:organization_application_id', to: "organization_applications#cancel", as: :cancel_organization_application

	match '/organization_application/r/pending/:id/', to: 'tutorials#pending_organization_application', as: :pending_organization_application

#---Secrets---

	match '/secrets', to: 'secrets#show', as: :secrets
	match '/:user_id/r/secrets/enter-a-secret', to: 'secrets#enter_secret', as: :enter_secret

#------Resources------
	resources :users, :path => '/' do
		resources :projects, :except => :index do
			resources :project_comments, :except => :index
			resources :majorposts, :except => :index do
				resources :comments, :except => :index
			end
			resources :archive
			resources :videos
			resources :artworks
			resources :icons
			resources :inviteds
			resources :assigned_projects

			#Inspirations
			resources :p_u_inspirations
			resources :p_p_inspirations
			resources :p_e_inspirations
		end
		resources :activites
		resources :bifrosts
		resources :ibifrosts
		resources :subscriptions
	end
	
	resources :majorpost_suggestions
	resources :project_suggestions
	resources :user_suggestions
	resources :tags_suggestions
	resources :updates
	resources :tags
	resources :messages
	resources :discussions
	resources :discussion_threads
	resources :subscription_applications

end


