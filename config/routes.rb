Rails.application.routes.draw do


	#Homepage
	root 'static_pages/home#home'

	#Blog
	get '(*path)' => 'application#blog', :constraints => {subdomain: 'blog'}
	get '/blog' => redirect("https://ratafire.com/blog/")	

	#User -----------------------------------
		devise_for :users, :controllers => {:omniauth_callbacks => "users/omniauth_callbacks",:registrations => "registrations" }
		#Profile Page
		get '/:username' => 'profile/user#profile', :as => 'profile_url'
		#User cards ajax
		get '/usercard/:uid/profile' => 'profile/usercard#usercard', :as => 'usercard'
	
	#Content -----------------------------------
		
		namespace :content do 
			#Majorposts
			resources :majorposts
		end
		#Tags
		get 'tags/:tag', to: 'discover/tag#tags', as: :tag

	#Friendship -----------------------------------

		namespace :friendship do
			#Friendships
			resources :friendship
		end
		#Display user friends
		get '/:username/friends' => 'friendship/friendship#friends', :as => 'friends'
end
