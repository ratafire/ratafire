class User < ActiveRecord::Base

    #----------------Utilities----------------

	#--------Devise--------
  	devise :database_authenticatable, 
  		:registerable,
        :recoverable, 
        :rememberable, 
        :trackable, 
        :validatable, 
        :confirmable, 
        :omniauthable, 
        :omniauth_providers => [
        	:facebook, 
        	:twitter, 
            :google_oauth2,
            :twitch,
            :pinterest,
            :soundcloud,
        	:github, 
        	:deviantart, 
        	:vimeo, 
        	:facebookpages, 
        	:facebookposts, 
        	:paypal
        ]

    #--------Friendly id for routing--------
    extend FriendlyId
    friendly_id :uid

    #--------Profile Photo--------- 
    #Escaped file name for paperclip
    Paperclip.interpolates :escaped_filename2 do |attachment, style|
        attachment.instance.normalized_profile_file_name
    end  
    #Normalized file name for paperclip
    def normalized_profile_file_name
        "#{self.id}-#{self.profilephoto_file_name.gsub( /[^a-zA-Z0-9_\.]/, '_')}"
    end

    #----------------Relationships----------------

    #--------User Info---------
    has_one :profilephoto, foreign_key: "user_uid", primary_key: "uid", class_name: "Profilephoto", dependent: :destroy
    has_one :profilecover, foreign_key: "user_uid", primary_key: "uid", class_name: "Profilecover", dependent: :destroy

    #--------Friends---------
    has_many :friendships, 
        -> { where( friendships: { :deleted_at => nil }) },
        :class_name => 'Friendship'
    has_many :friends, 
        :through => :friendships
    has_many :inverse_friendships,
        -> { where( friendships: { :deleted_at => nil }) },
        :class_name => "Friendship", 
        :foreign_key => "friend_id"
    has_many :inverse_friends, 
        :through => :inverse_friendships, 
        :source => :user        

    #--------Subscriptions---------
    has_many :subscriptions, 
        -> { where( subscriptions: { :deleted_at => nil, :activated => true }) },
        foreign_key: "subscribed_id", 
        class_name: "Subscription", 
        dependent: :destroy
    has_many :subscribers, 
        -> { where( subscriptions: { :deleted_at => nil, :activated => true }) },
        through: :subscriptions, 
        source: :subscriber

    has_many :reverse_subscriptions, 
        -> { where( subscriptions: { :deleted_at => nil, :activated => true }) },
        foreign_key: "subscriber_id", 
        class_name: "Subscription", 
        dependent: :destroy
    has_many :subscribed, 
        -> { where( subscriptions: { :deleted_at => nil, :activated => true }) },
        through: :reverse_subscriptions, 
        source: :subscribed

    #--------Payment---------
    has_one :paypal_account,
        -> { where( paypal_accounts: { :deleted_at => nil, :organization_id => nil, :organization_application_id => nil }) }

    #--------Record Backers---------
    has_many :subscription_records, 
        foreign_key: "subscribed_id", 
        class_name: "SubscriptionRecord", 
        dependent: :destroy
    has_many :record_subscribers, 
        through: :subscription_records, 
        source: :subscriber

    has_many :reverse_subscription_records, 
        foreign_key: "subscriber_id", 
        class_name: "SubscriptionRecord", 
        dependent: :destroy
    has_many :record_subscribed, 
        through: :reverse_subscription_records, 
        source: :subscribed

    #--------Content---------
    has_many :majorpost
        has_many :artwork
        has_many :link
        has_many :audio
            has_many :audio_image
        has_many :video
            has_many :video_image

    #--------Campaign---------
    has_many :campaigns
        has_one :active_campaign,
            -> { where( campaigns: { :deleted_at => nil, :published => true, :completed => false }) },
            class_name: "Campaign"

    #----------------Social Media----------------
    #--------Facebook---------
    has_one :facebook, 
        -> { where( facebooks: { :deleted_at => nil}) }
        has_many :facebook_pages,
            -> { where( facebook_pages: { :deleted_at => nil}) }
    #--------Twitter---------
    has_one :twitter,
        -> { where( twitters: { :deleted_at => nil}) }
    #--------Github---------
    has_one :github,
        -> { where( githubs: { :deleted_at => nil}) }
    #--------Deviantart---------
    has_one :deviantart,
        -> { where( deviantarts: { :deleted_at => nil}) }
    #--------Youtube---------
    has_one :youtube,
        -> { where( youtubes: { :deleted_at => nil}) }
    #--------Tumblr---------
    has_one :tumblr,
        -> { where( tumblrs: { :deleted_at => nil}) }
    #--------Tiwtch---------
    has_one :twitch,
        -> { where( twitches: { :deleted_at => nil}) }
    #--------SoundCloud---------
    has_one :soundcloud_oauth,
        -> { where( soundcloud_oauths: { :deleted_at => nil}) }
    #--------Vimeo---------
    has_one :vimeo,
        -> { where( vimeos: { :deleted_at => nil}) }
    #--------Pinterest---------
    has_one :pinterest,
        -> { where( pinterests: { :deleted_at => nil}) }

    #----------------Validation----------------
    #Real Name
    validates :firstname, :presence => true
    validates :lastname, :presence => true

    #Email
    validates :email, :presence => true, format: {with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i}, uniqueness: { case_sensitive: false }

    #Username
    validates :username, :presence => true, format: {with: /\A[a-zA-Z0-9_]+\z/}, uniqueness: { case_sensitive: false }, length: { in: 3..50 }

    #User Info
    validates :tagline, length: { in: 3..42 }
    validates :website, length: { in: 3..100 }, format: {with: /(^$)|(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/ix}
    validates :bio, length: { in: 0..214 }
end