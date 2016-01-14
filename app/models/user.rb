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
        	:github, 
        	:deviantart, 
        	:vimeo, 
        	:venmo, 
        	:facebookpages, 
        	:facebookposts, 
        	:paypal
        ]

    #--------Friendly id for routing--------
    extend FriendlyId
    friendly_id :username

    #--------Profile Photo---------
    has_attached_file :profilephoto, :styles => { :medium => "256x256#", :small => "128x128#", :small64 => "64x64#", :tiny => "40x40#"}, :default_url => "/assets/usericon_:style.png",
        :url => ":class/:id/:style/:escaped_filename2",:hash_secret => "longSecretString",
        :path => ":class/:id/:style/:escaped_filename2",
        :storage => :s3,
        :s3_credentials => "#{Rails.root}/config/s3_profile.yml"    
    #Escaped file name for paperclip
    Paperclip.interpolates :escaped_filename2 do |attachment, style|
        attachment.instance.normalized_profile_file_name
    end  
    #Normalized file name for paperclip
    def normalized_profile_file_name
        "#{self.id}-#{self.profilephoto_file_name.gsub( /[^a-zA-Z0-9_\.]/, '_')}"
    end

    #----------------Relationships----------------

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

    #----------------Social Media----------------
    #--------Facebook---------
    has_one :facebook, 
        -> { where( facebooks: { :deleted_at => nil}) }
    #--------Twitter---------
    has_one :twitter
    #--------Github---------
    has_one :github
    #--------Deviantart---------
    has_one :deviantart
    #--------Youtube---------
    has_one :youtube
    #--------Tumblr---------
    has_one :tumblr
    #--------Tiwtch---------
    has_one :twitch
    #--------Pinterest---------
    has_one :pinterest
end