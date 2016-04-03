Rails.application.routes.draw do

	#Homepage
	root 'static_pages/home#home'

	#Blog
	get '(*path)' => 'application#blog', :constraints => {subdomain: 'blog'}
	get '/blog' => redirect("https://ratafire.com/blog/")	

	#User -----------------------------------

		resources :users, only: [:update], shallow: true do 
			#Methods in users_controller
			get 'disconnect/:provider', to: 'users#disconnect', as: :disconnect
			#Admin
			namespace :admin do
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
				#resource :tabs, only:[] do
				#	get 'friends'
				#	get 'backers'
				#	get 'backed'
				#	get 'subscribed'
				#end
				#Settings
				resource :settings, only:[] do
					get 'profile_settings'
					get 'social_media_settings'
					get 'language_settings'
					get 'account_settings'
				end
			end	

			#Creator studio
			namespace :studio do 
				#Creator studio
				resource :creator_studio, only:[] do
					get 'dashboard'
				end
				#campaign
				resource :campaigns, only:[:new,:create] do
					get ':campaign_id/art', to: 'campaigns#art', as: :art
					patch ':campaign_id/update', to: 'campaigns#update', as: :update
					get ':campaign_id/apply', to: 'campaigns#apply', as: :apply
					post ':campaign_id/campaign_video', to: 'campaigns#campaign_video', as: :campaign_video
					post ':campaign_id/campaign_video_image', to: 'campaigns#campaign_video_image', as: :campaign_video_image
					delete ':campaign_id/campaign_video', to:'campaigns#remove_campaign_video', as: :remove_campaign_video
				end
			end

		end

	

		devise_for :users, :controllers => {:omniauth_callbacks => "users/omniauth_callbacks",registrations: 'users/registrations' }
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
			resources :majorposts, only:[:create, :destroy]
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
			#Special url to upload artwork from medium editor
			post '/content/artworks/medium_editor_upload_artwork/:majorpost_uuid' => 'content/artworks#medium_editor_upload', method: :post, :as => 'medium_editor_upload_artwork'

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
		resource :historical_quotes, only:[] do
			get '/index', to: 'historical_quotes#index', as: :index
			get '/:id', to: 'historical_quotes#edit', as: :edit
			patch '/:id', to: 'historical_quotes#update', as: :update
		end
	end

	#Resque -----------------------------------

	authenticate :user, lambda {|u| u.admin == true } do
	    mount Resque::Server, :at => "/admin/resque"
	end		
end
