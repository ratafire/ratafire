Ratafire::Application.routes.draw do

  mathjax 'mathjax'

  get "activities/index"

  #devise_for :users, :controllers => { :registrations => "registrations"}
  devise_scope :user do
    get "/users/sign_up",  :to => "users#no_sign_up"
  end
  devise_for :users, :controllers => { :invitations => 'users/invitations', :omniauth_callbacks => "users/omniauth_callbacks" }

  mount RedactorRails::Engine => '/redactor_rails'
  mount Resque::Server, :at => "/resque"

  get "users/new"

#---Home Page---

 

    #authenticated :user do
    #root :to => 'static_pages#contact', :as => "authenticated_root"
    # Rails 4 users must specify the 'as' option to give it a unique name
    # root :to => "main#dashboard", :as => "authenticated_root"
    #end

     root to: 'static_pages#home'


#---Static Pages Matches---
  match '/help', to: 'static_pages#help'
  match '/terms', to: 'static_pages#terms', as: :terms
  match '/privacy', to: 'static_pages#privacy', as: :privacy
  match '/about', to: 'static_pages#about'
  match '/contact', to: 'static_pages#contact'
  match '/discovered', to: 'static_pages#discovered', as: :discovered_path

#---Projects Matches---
  match ':user_id/:id/about', to: 'projects#about', as: :project_about
  match ':user_id/:id/contributors', to: 'projects#contributors', as: :project_contributors
  match ':user_id/:id/mplist', to: 'projects#mplist', as: :project_mplist
  match ':user_id/:id/settings', to: 'projects#settings', as: :project_settings
  match ':user_id/:id/archive', to: 'archives#archive', as: :project_archives
  match ':user_id/:id/archive/videos', to: 'archives#videos', as: :project_archive_videos
  match ':user_id/:id/archive/artwork', to: 'archives#artwork', as: :project_archive_artwork
  match ':user_id/projects/:id/realm', to: 'projects#realm',as: :project_realms

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
  match ':user_id/projects/:id/you-shall-not-pass', to: 'projects#abandon', via: :get,as: :you_shall_not_pass
  match ':user_id/projects/:id/i-will-be-back', to: 'projects#reopen', as: :i_will_be_back

#---Majorposts Matches---

  match ':user_id/:project_id/:id', to: 'majorposts#show', as: :user_project_majorpost
  match ':user_id/projects/:project_id/majorposts/:id', to: 'majorposts#destroy', via: :delete, as: :majorpost_delete
  match ':user_id/:id/r/newmajorpost', to: 'majorposts#create',via: :post, as: :new_majorpost
  match ':user_id/projects/:project_id/majorposts/:id', to: 'majorposts#update', via: :put, as: :majorpost_update

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

  match ':id/r/settings/goals', to: 'users#goals', as: :goals
  match ':id/r/settings/profile', to: 'users#edit', as: :edit_user
  match ':id/r/settings/profile#bio-edit', to: 'users#edit', as: :edit_bio
  match ':id/r/settings/profile#social-media', to: 'users#edit', as: :edit_socialmedia
  match ':id/r/settings/subscription', to: 'subscriptions#settings', as: :subscription_settings
  match ':id/r/settings/profilephoto/delete', to: 'users#profile_photo_delete', via: :delete, as: :photo_delete
  match ':id/r/users/disable/user', to: 'users#disable', via: :post, as: :disable_user

  match ':user_id/activities/delete/:id', to: 'activities#destroy', via: :delete, as: :activity_delete

#---Video Upload---
   match ":user_id/projects/:project_id/videos/:id", :to => "videos#destroy", via: :delete, as: :project_video_delete
   match "/videos/notification/r/encode_notify", :to => "videos#encode_notify"

#---Artwork---
   match ":user_id/:project_id/artworks/delete/:id", to: 'artworks#destroy', via: :delete, as: :artwork_delete
   match ':user_id/projects/:project_id/artworks/:id', to: 'artworks#download', :controller => "artworks",:action => 'download', :conditions => { :method => :get }, as: :artwork_download

#---Icon ---
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
  match ':id/r/subscriptions/subscribers', to: 'subscriptions#subscribers', as: :subscribers  
  match ':id/r/subscriptions/subscribing', to: 'subscriptions#subscribing', as: :subscribing
  match ':id/r/subscriptions/remove/:subscriber_id', to: 'subscriptions#destroy', via: :delete, as: :remove_subscriber
  match ':id/r/subscriptions/unsubscribe/:subscribed_id', to: 'subscriptions#unsub', via: :delete, as: :unsubscribe
  match ':id/r/subscriptions/subscribers_past', to: 'subscriptions#subscribers_past', as: :subscribers_past
  match ':id/r/subscriptions/subscribing_past', to: 'subscriptions#subscribing_past', as: :subscribing_past

  match ':id/r/subscriptions/subscription_on', to: 'subscriptions#turnon', as: :subscription_turnon
  match ':id/r/subscriptions/subscription_off', to: 'subscriptions#turnoff', as: :subscription_turnoff

  #Amazon Payments
  match ':id/r/subscriptions/amazon_payments_connect', to: 'amazon#pre_create_recipient', as: :connect_to_amazon_payments
  match 'r/subscriptions/amazon_payments/recipient/postfill', to: 'amazon#post_create_recipient', :via => [:get, :post]
  match ':id/subscriptions/amazon_payments/recipient/cancel', to: 'amazon#cancel_recipient', as: :cancel_recipient
  match ':id/subscriptions/amazon_payments/recipient/reconnect', to: 'amazon#reconnect_recipient', as: :reconnect_recipient
  match 'r/subscriptions/amazon_payments/subscribe/post_subscribe', to: 'amazon#post_subscribe', :via => [:get, :post]
#---Payments---
  match ':id/r/payments/why', to:'subscriptions#why', as: :why
  match ':id/r/payments/subscribe', to: 'subscriptions#new', as: :subscribe
  match ':id/r/payments/checkout_amazon', to: 'subscriptions#amazon', as: :amazon
  match ':id/r/payments/subscription/create', to: 'subscriptions#create',via: :post, as: :create_subscription

#---Updates---
  match ':id/r/interesting/homepage', to: 'updates#interesting', as: :interesting_homepage
  match ':id/r/subscribing/update', to: 'updates#subscribing_update', as: :subscribing_update 
  match ':id/r/followed_tags/update', to: 'updates#followed_tags', as: :followed_tags 
  match ':id/r/liked/update', to: 'updates#liked', as: :liked

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

  match '/r/realms/veryseriously/more/:realm', to: 'updates#realm_selector', as: :realm_selector

#---Tags---
  match 'tags/-/-/:tag', to: 'updates#tags', as: :tag 
  match 'tags/follow_tag/:user_id/:tag_id', to: 'tag_relationships#follow', as: :follow_tag 
  match 'tags/unfollow_tag/:user_id/:tag_id', to: 'tag_relationships#destroy', as: :unfollow_tag
  match 'tags/-/-/:tag/followers', to: 'updates#tag_followers', as: :tag_followers

#---Like---
  match 'like/project/-/:project_id/:user_id', to: 'likes#project', as: :like_project
  match 'like/majorpost/-/:majorpost_id/:user_id', to: 'likes#majorpost', as: :like_majorpost
  match 'like/comment/-/:comment_id/:user_id', to: 'likes#comment', as: :like_comment

  match 'unlike/project/-/:project_id/:user_id', to: 'likes#unlike_project',as: :unlike_project
  match 'unlike/majorpost/-/:majorpost_id/:user_id', to: 'likes#unlike_majorpost', as: :unlike_majorpost
  match 'unlike/comment/-/:comment_id/:user_id', to: 'likes#unlike_comment', as: :unlike_comment

#---Errors---

#---Beta---
  match '/beta', to: 'beta_users#new', as: :beta
  match '/beta/user/beta/beta/betainvite', to: 'beta_users#create', via: :post,as: :beta_create
  match '/beta_status', to: 'beta_users#status', as: :beta_status

#---Admin---
  #Beta
  match '/beta_admin', to: 'beta_users#show', as: :beta_admin
  match '/:id/r/ratafire/welcome-new-friend/beta_approve', to: 'beta_users#approve',as: :beta_approve
  match '/:id/r/ratafire/welcome-new-friend/beta_ignore', to: 'beta_users#ignore', as: :beta_ignore

#---Resources---
  resources :users, :path => '/' do
    resources :projects, :except => :index do
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

end
