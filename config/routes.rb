Rails.application.routes.draw do

	#Homepage
	root 'static_pages/home#home'

	#Blog
	get '(*path)' => 'application#site', :constraints => {subdomain: 'site'}
	get '/site' => redirect("https://ratafire.com/site/")	

	#Stripe
	mount StripeEvent::Engine, at: '/stripe_chashuibiao'

	#User -----------------------------------

		resources :users, only: [], shallow: true do 
			#Methods in users_controller
			get 'disconnect/:provider', to: 'users#disconnect', as: :disconnect
			patch 'update_user', to:'users#update_user', as: :update_user
			#Admin
			namespace :admin do
				resource :dashboard, only:[] do
					get 'dashboard'
				end
				resource :campaigns, only:[:show] do
				end
				resource :tags, only:[:show, :create] do 
				end
				resource :historical_quotes, only:[:show, :create,:destroy] do
				end
			end
			#Editor
			namespace :editor do 
				#Ajax responses to show the editor
				resources :editor_text, only: [:new]
				resources :editor_image, only: [:new]		
				resources :editor_link, only: [:new]
				resources :editor_audio, only: [:new]
				resources :editor_video, only: [:new]
			end	
			#Update User Info
			namespace :userinfo do
				resources :profilephotos, only: [:create,:update,:destroy]
				resources :profilecovers, only: [:create, :update,:destroy]
			end

			#Profile page display
			namespace :profile do
				#Tabs for profile page
				resource :tabs, only:[] do
					get 'friends'
					get 'gallery'
					get 'videos'
				end
				#Settings
				resource :settings, only:[] do
					get 'profile_settings'
					get 'social_media_settings'
					get 'language_settings'
					get 'account_settings'
					get 'notification_settings'
					get 'identity_verification'
				end
				#Identity Verification
				resource :identity_verifications, only:[:create] do
					get 'resend_identity_verification', to: 'identity_verifications#resend_identity_verification', as: :resend_identity_verification
				end
			end	

			#Creator studio
			namespace :studio do 
				#Creator studio
				resource :creator_studio, only:[] do
					get 'dashboard'
					get 'campaigns'
					get 'rewards'
					get 'current_goal'
					get 'notifications'
				end
				#Wallet
				resource :wallets, only:[] do
					get 'how_i_pay'
					get 'how_i_get_paid'
					get 'upcoming'
					get 'upcoming_datatable', to: 'wallets#upcoming_datatable', as: :upcoming_datatable
					get 'receipts', to: 'wallets#receipts', as: :receipts
					get 'single_receipt/:transaction_id', to: 'wallets#single_receipt', as: :single_receipt
					get 'single_receipt_datatable/:transaction_id', to: 'wallets#single_receipt_datatable', as: :single_receipt_datatable
					get 'transfers'
				end
				#Shipping address
				resource :shipping_addresses, only:[:create] do
					get 'my_mailing_address'
					get '/:shipping_address_id', to: 'shipping_addresses#edit', as: :edit
					patch '/:shipping_address_id', to: 'shipping_addresses#update', as: :update
					delete '/:shipping_address_id', to: 'shipping_addresses#destroy', as: :destroy
				end
				#campaign
				resource :campaigns, only:[:new,:create] do
					get ':campaign_id/edit', to: 'campaigns#edit', as: :edit
					get ':campaign_id/application', to: 'campaigns#application', as: :application
					patch ':campaign_id/update', to: 'campaigns#update', as: :update
					post ':campaign_id/update', to: 'campaigns#post_update', as: :post_update
					get ':campaign_id/apply', to: 'campaigns#apply', as: :apply
					post ':campaign_id/campaign_video', to: 'campaigns#campaign_video', as: :campaign_video
					post ':campaign_id/campaign_video_image', to: 'campaigns#campaign_video_image', as: :campaign_video_image
					delete ':campaign_id/campaign_video', to:'campaigns#remove_campaign_video', as: :remove_campaign_video
					delete ':campaign_id/campaign_image', to: 'campaigns#remove_campaign_image', as: :remove_campaign_image
					get ':campaign_id/submit_application', to: 'campaigns#submit_application', as: :submit_application
					get ':campaign_id/display_read_all', to: 'campaigns#display_read_all', as: :display_read_all
					post ':campaign_id/upload_image', to: 'campaigns#upload_image', as: :upload_image
					get ':campaign_id/upload_image_edit', to: 'campaigns#upload_image_edit', as: :upload_image_edit
					get ':campaign_id/update_content_edit', to: 'campaigns#update_content_edit', as: :update_content_edit
					get ':campaign_id/update_content_cancel', to: 'campaigns#update_content_cancel', as: :update_content_cancel
					post ':campaign_id/mark_as_completed', to: 'campaigns#mark_as_completed', as: :mark_as_completed
					get ':campaign_id/completed', to: 'campaigns#completed', as: :completed
					post ':campaign_id/abandon', to: 'campaigns#abandon', as: :abandon
					delete ':campaign_id/delete', to: 'campaigns#delete', as: :delete
				end
				#reward
				resource :rewards, only:[:new, :create] do
					post ':reward_id/upload_image', to: 'rewards#upload_image', as: :upload_image
					delete ':reward_id/remove_image', to: 'rewards#remove_image', as: :remove_image
					get '/show/:reward_id', to: 'rewards#show', as: :show
					get '/receiver_datatable/:reward_id', to: 'rewards#receiver_datable', as: :receiver_datatable
					get '/upload_image_edit/edit/edit', to: 'rewards#upload_image_edit', as: :upload_image_edit
					get 'my_rewards'
					get 'my_rewards_datatable'
					get '/confirm_shipping_payment/:shipping_order_id', to: 'rewards#confirm_shipping_payment', as: :confirm_shipping_payment
					get '/upload_reward_editor/:reward_id', to: 'rewards#upload_reward_editor', as: :upload_reward_editor
					post '/upload_reward/:reward_id', to: 'rewards#upload_reward', as: :upload_reward
					post '/confirm_upload_reward/:reward_id', to: 'rewards#confirm_upload_reward', as: :confirm_upload_reward
					post '/end_early/:reward_id', to: 'rewards#end_early', as: :end_early
					post '/make_active/:reward_id', to: 'rewards#make_active', as: :make_active
					delete '/abandon/:reward_id', to: 'rewards#abandon', as: :abandon
				end
				#Notification
				resource :notifications, only:[] do
					get '/get_notifications', to: 'notifications#get_notifications', as: :get_notifications
				end
				#Community
				resource :community, only: [] do
					get 'backed', to: 'community#backed', as: :backed
					get 'backers', to: 'community#backers', as: :backers
					get 'followed', to: 'community#followed', as: :followed
					get 'followers', to: 'community#followers', as: :followers
					get 'backed_datatable', to: 'community#backed_datatable', as: :backed_datatable
					get 'backers_datatable', to: 'community#backers_datatable', as: :backers_datatable
					get 'followed_datatable', to: 'community#followed_datatable', as: :followed_datatable
					get 'followers_datatable', to: 'community#followers_datatable', as: :followers_datatable 
				end
				#Traits
				resource :traits, only: [:show] do
					post 'create/:trait_id', to: 'traits#create', as: :create
					delete 'destroy/:trait_id', to: 'traits#destroy', as: :destroy
				end
				#shipping
				#resources :shippings, shallow: true, only:[] do
				#	post 'shipping/:user_id/:campaign_id/:reward_id/:amount/:country', to:'shippings#create_shipping',as: :create_shipping
				#	post 'shipping_anywhere/:user_id/:campaign_id/:reward_id/:amount', to:'shippings#create_shipping_anywhere', as: :create_shipping_anywhere
				#	delete 'shipping/:shipping_id', to:'shippings#delete_shipping', as: :delete_shipping
				#	delete 'shipping_anywhere/:shipping_anywhere_id', to:'shippings#delete_shipping_anywhere', as: :delete_shipping_anywhere
				#end
			end

			#payment
			namespace :payment do 
				#bank account
				resource :bank_accounts, only:[:create, :update, :destroy] do
					get 'edit'
				end
				#card
				resource :cards, only:[:create, :update, :destroy] do
					get 'edit'
				end
				#back
				resource :backs, only:[:new, :create] do
					get 'country/:country_id', to: 'backs#country', as: :country
					get 'payment', to: 'backs#payment', as: :payment
				end
				#subscription
				resource :subscriptions, only:[:create, :destroy] do
					delete 'unsub', to: 'subscriptions#unsub', as: :unsub 
				end
				#confirm payment
				resource :confirm_payments, only:[:create] do
					get 'thankyou'
				end
				#reward receiver
				resource :reward_receivers, only:[] do
					get '/:reward_receiver_id/request_shipping_fee', to: 'reward_receivers#request_shipping_fee', as: :request_shipping_fee
					post '/:shipping_order_id/confirm_payment', to: 'reward_receivers#confirm_payment', as: :confirm_payment
					delete '/:shipping_order_id/cancel_payment', to: 'reward_receivers#cancel_payment', as: :cancel_payment	
					get '/:reward_receiver_id/ship_reward', to: 'reward_receivers#ship_reward', as: :ship_reward	
					post '/:reward_receiver_id/ship_reward_now', to: 'reward_receivers#ship_reward_now', as: :ship_reward_now 
				end	
				#Transfer
				resource :transfers, only:[:create] do 
					get '/transfer_datatable', to: 'transfers#transfer_datatable', as: :tansfer_datatable
				end
			end

			#content
			namespace :content do
				resource :likes, only:[:show] do
					get '/majorpost/:majorpost_id', to:'likes#majorpost', as: :majorpost
					get '/campaign/:campaign_id', to:'likes#campaign', as: :campaign
					get '/user/:user_id', to:'likes#user', as: :user
					delete '/majorpost/:majorpost_id', to:'likes#unlike_majorpost', as: :unlike_majorpost
					delete '/campaign/:campaign_id', to:'likes#unlike_campaign', as: :unlike_campaign
					delete '/user/:user_id', to:'likes#unlike_user', as: :unlike_user
					delete '/remove_liker/:user_id', to: 'likes#remove_liker', as: :remove_liker
					get '/followed_pagination', to: 'likes#followed_pagination', as: :followed_pagination
				end
			end

		end

	

		devise_for :users, :controllers => {:omniauth_callbacks => "users/omniauth_callbacks",registrations: 'users/registrations', sessions: "users/sessions" }
		#Profile Page
		get '/:username' => 'profile/user#profile', :as => 'profile_url'
		#User cards ajax
		get '/usercard/:uid/profile' => 'profile/usercard#usercard', :as => 'usercard'
		#Editor -----------------
			#Special url to remove editors
			get '/user/:user_id/editor/editor_text/:majorpost_uuid' => 'editor/editor_text#remove', method: :get, :as => 'remove_user_editor_editor_text'
			get '/user/:user_id/editor/editor_image/:majorpost_uuid' => 'editor/editor_image#remove', method: :get, :as => 'remove_user_editor_editor_image'
			get '/user/:user_id/editor/editor_link/:majorpost_uuid' => 'editor/editor_link#remove', method: :get, :as => 'remove_user_editor_editor_link'
			get '/user/:user_id/editor/editor_audio/:majorpost_uuid' => 'editor/editor_audio#remove', method: :get, :as => 'remove_user_editor_editor_audio'
			get '/user/:user_id/editor/editor_video/:majorpost_uuid' => 'editor/editor_video#remove', method: :get, :as => 'remove_user_editor_editor_video'

	#Content -----------------------------------
		
		namespace :content do 
			#Majorposts
			resources :majorposts, only:[:create, :destroy, :show] do
				get 'read_more'
				post '/set_category/:category_id', to: 'majorposts#set_category', as: :set_category
				post '/set_sub_category/:category_id/:sub_category_id', to: 'majorposts#set_sub_category', as: :set_sub_category
			end
				#Majorpost attachments
				resources :artworks, only:[:create,:destroy] do
					delete 'remove'
				end
				resources :links, only:[:create, :destroy] do
				end
				resources :audios, only:[:create, :destroy] do 
				end
					resources :audio_images, only:[:create] do
					end
				resources :videos, only:[:create, :destroy] do
				end
					resources :video_images, only:[:create] do
					end
		end
		#Artworks -----------------
			#Special url to upload artwork from medium editor for majorpost
			post '/content/artworks/medium_editor_upload_artwork/:majorpost_uuid' => 'content/artworks#medium_editor_upload', method: :post, :as => 'medium_editor_upload_artwork'

			#Special url to upload artwork from medium editor for 
			post '/content/artworks/medium_editor_upload_artwork_campaign/:campaign_uuid' => 'content/artworks#medium_editor_upload_campaign', method: :post, :as => 'medium_editor_upload_artwork_campaign'
		#Videos -----------------
			#Special url for Zencoder to notify the application
			post '/video/zencoder_notify_encode', to: 'content/videos#encode_notify'

		#Tags -----------------
			get 'tags/:tag', to: 'explore/tags#tags', as: :tag
			get 'tags/followed_pagination/get_them', to: 'explore/tags#followed_pagination', as: :followed_pagination

		#Categories -----------------
			get 'explore/ratafire', to: 'explore/explore#explore', as: :explore

			get 'explore/categories/art', to: 'explore/categories#art', as: :art_category
			get 'explore/categories/music', to: 'explore/categories#music', as: :music_category
			get 'explore/categories/games', to: 'explore/categories#games', as: :games_category
			get 'explore/categories/writing', to: 'explore/categories#writing', as: :writing_category
			get 'explore/categories/videos', to: 'explore/categories#videos', as: :videos_category

			#Art
			get 'explore/categories/art/a_new_field', to: 'explore/categories#art_a_new_field', as: :art_a_new_field
			get 'explore/categories/art/concept_art', to: 'explore/categories#art_concept_art', as: :art_concept_art
			get 'explore/categories/art/3D_model', to: 'explore/categories#art_3d_model', as: :art_3d_model
			get 'explore/categories/art/drawing', to: 'explore/categories#art_drawing', as: :art_drawing
			get 'explore/categories/art/painting', to: 'explore/categories#art_painting', as: :art_painting
			get 'explore/categories/art/architecture', to: 'explore/categories#art_architecture', as: :art_architecture
			get 'explore/categories/art/interior_design', to: 'explore/categories#art_interior_design', as: :art_interior_design
			get 'explore/categories/art/photography', to: 'explore/categories#art_photography', as: :art_photography
			get 'explore/categories/art/graphic_design', to: 'explore/categories#art_graphic_design', as: :art_graphic_design
			get 'explore/categories/art/sculpting', to: 'explore/categories#art_sculpting', as: :art_sculpting
			get 'explore/categories/art/jewelry_design', to: 'explore/categories#art_sculpting', as: :art_jewelry_design
			get 'explore/categories/art/other', to: 'explore/categories#art_other', as: :art_other

			#Music
			get 'explore/categories/music/a_new_field', to: 'explore/categories#music_a_new_field', as: :music_a_new_field
			get 'explore/categories/music/composition', to: 'explore/categories#composition', as: :music_composition
			get 'explore/categories/music/soundtrack', to: 'explore/categories#music_soundtrack', as: :music_soundtrack
			get 'explore/categories/music/rock', to: 'explore/categories#music_rock', as: :music_rock
			get 'explore/categories/music/pop', to: 'explore/categories#music_pop', as: :music_pop
			get 'explore/categories/music/cover', to: 'explore/categories#music_cover', as: :music_cover
			get 'explore/categories/music/classical', to: 'explore/categories#music_classical', as: :music_classical
			get 'explore/categories/music/other', to: 'explore/categories#music_other', as: :music_other

			#Games
			get 'explore/categories/games/a_new_field', to: 'explore/categories#games_a_new_field', as: :games_a_new_field
			get 'explore/categories/games/rpg', to: 'explore/categories#games_rpg', as: :games_rpg
			get 'explore/categories/games/strategy', to: 'explore/categories#games_strategy', as: :games_strategy
			get 'explore/categories/games/simulation', to: 'explore/categories#games_simulation', as: :games_simulation
			get 'explore/categories/games/mmo', to: 'explore/categories#games_mmo', as: :games_mmo
			get 'explore/categories/games/action', to: 'explore/categories#games_action', as: :games_action
			get 'explore/categories/games/sport', to: 'explore/categories#games_sport', as: :games_sport
			get 'explore/categories/games/adventure', to: 'explore/categories#games_adventure', as: :games_adventure
			get 'explore/categories/games/other', to: 'explore/categories#games_other', as: :games_other

			#Writing
			get 'explore/categories/writing/a_new_field', to: 'explore/categories#writing_a_new_field', as: :writing_a_new_field
			get 'explore/categories/writing/review', to: 'explore/categories#writing_review', as: :writing_review
			get 'explore/categories/writing/poetry', to: 'explore/categories#writing_poetry', as: :writing_poetry
			get 'explore/categories/writing/fantasy', to: 'explore/categories#writing_fantasy', as: :writing_fantasy
			get 'explore/categories/writing/science_fiction', to: 'explore/categories#writing_science_fiction', as: :writing_science_fiction
			get 'explore/categories/writing/non_fiction', to: 'explore/categories#writing_non_fiction', as: :writing_non_fiction
			get 'explore/categories/writing/fiction', to: 'explore/categories#writing_fiction', as: :writing_fiction
			get 'explore/categories/writing/other', to: 'explore/categories#writing_other', as: :writing_other

			#Videos
			get 'explore/categories/videos/a_new_field', to: 'explore/categories#videos_a_new_field', as: :videos_a_new_field
			get 'explore/categories/videos/gaming', to: 'explore/categories#videos_gaming', as: :videos_gaming
			get 'explore/categories/videos/animation', to: 'explore/categories#videos_animation', as: :videos_animation
			get 'explore/categories/videos/cg', to: 'explore/categories#videos_cg', as: :videos_cg
			get 'explore/categories/videos/movies', to: 'explore/categories#videos_movies', as: :videos_movies
			get 'explore/categories/videos/documentary', to: 'explore/categories#videos_documentary', as: :videos_documentary
			get 'explore/categories/videos/tutorial', to: 'explore/categories#videos_tutorial', as: :videos_tutorial
			get 'explore/categories/videos/other', to: 'explore/categories#videos_other', as: :videos_other			

			#Back creators
			get 'explore/back_creators/', to: 'explore/explore#back_creators', as: :back_creators

	#Explore -----------------------------------

		namespace :explore do
			resources :tags, only:[] do
				post 'follow'
				delete 'unfollow'
			end
			resources :categories, only:[:index] do
				get 'explore/categories/:category_id', to: 'categories#category', as: :category
				get 'explore/categories/:category_id/:sub_category_id', to: 'categories#sub_category', as: :sub_category
			end
			resources :explore, only:[] do
				get 'surprise_me', to: 'explore#surprise_me', as: :surprise_me
			end
		end 

	#International -----------------------------------
		namespace :global do
			#Basic
			get ':locale/switch', to: 'software_language#switch', as: :switch
		end

	#Friendship -----------------------------------

		namespace :friendship do
			#Friendships
			resources :friendship
		end
		#Display user friends
		get '/:username/friends' => 'friendship/friendship#friends', :as => 'friends'

	#Datatable & Edit -----------------------------------

	#Admin
	namespace :admin do
		resource :campaigns, only:[] do
			get '/index', to: 'campaigns#index', as: :index
			get '/review/:campaign_id', to: 'campaigns#review', as: :review 
			get '/approve/:campaign_id', to: 'campaigns#approve', as: :approve
			get '/disapprove/:campaign_id', to: 'campaigns#disapprove', as: :disapprove
		end
		resource :tags, only:[:show] do 
			get '/index', to: 'tags#index', as: :index
			get '/:id', to: 'tags#edit', as: :edit
			delete '/:id', to: 'tags#destroy', as: :destroy
			patch '/:id', to: 'tags#update', as: :update
		end
		resource :historical_quotes, only:[] do
			get '/index', to: 'historical_quotes#index', as: :index
			get '/:id', to: 'historical_quotes#edit', as: :edit
			patch '/:id', to: 'historical_quotes#update', as: :update
		end
	end

	#Payment -----------------------------------


	#Resque -----------------------------------

	authenticate :user, lambda {|u| u.admin == true } do
	    mount Resque::Server, :at => "/admin/resque", as: :resque
	end		

end
