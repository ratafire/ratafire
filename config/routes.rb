Rails.application.routes.draw do

	#Homepage
	root 'static_pages/home#home'

	#Blog
	get '(*path)' => 'application#blog', :constraints => {subdomain: 'blog'}
	get '/blog' => redirect("https://ratafire.com/blog/")	

	#User -----------------------------------

		resources :users, except: [:show], shallow: true do 
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
			resources :majorposts
				#Majorpost attachments
				resources :artworks do
					delete 'remove'
				end
				resources :links do
				end
				resources :audios do 
				end
					resources :audio_images do
					end
				resources :videos do
				end
					resources :video_images do
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

	#Friendship -----------------------------------

		namespace :friendship do
			#Friendships
			resources :friendship
		end
		#Display user friends
		get '/:username/friends' => 'friendship/friendship#friends', :as => 'friends'

	#Resque -----------------------------------

	authenticate :user, lambda {|u| u.admin == true } do
	    mount Resque::Server, :at => "/admin/resque"
	end		
end
