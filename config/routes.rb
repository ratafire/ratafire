Rails.application.routes.draw do

	#Homepage
	root 'static_pages/home#home'

	#Blog
	get '(*path)' => 'application#blog', :constraints => {subdomain: 'blog'}
	get '/blog' => redirect("https://ratafire.com/blog/")	

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
				end
				#reward
				resource :rewards, only:[:new, :create] do
					post ':reward_id/upload_image', to: 'rewards#upload_image', as: :upload_image
					delete ':reward_id/remove_image', to: 'rewards#remove_image', as: :remove_image
					get '/:reward_id', to: 'rewards#show', as: :show
					get '/receiver_datatable/:reward_id', to: 'rewards#receiver_datable', as: :receiver_datatable
				end
				#Notification
				resource :notifications, only:[] do
					get '/get_notifications', to: 'notifications#get_notifications', as: :get_notifications
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
			get 'tags/:tag', to: 'discover/tag#tags', as: :tag

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
		resource :historical_quotes, only:[] do
			get '/index', to: 'historical_quotes#index', as: :index
			get '/:id', to: 'historical_quotes#edit', as: :edit
			patch '/:id', to: 'historical_quotes#update', as: :update
		end
	end

	#Resque -----------------------------------

	authenticate :user, lambda {|u| u.admin == true } do
	    mount Resque::Server, :at => "/admin/resque", as: :resque
	end		

end
