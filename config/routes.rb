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
end
