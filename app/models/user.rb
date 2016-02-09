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

    #--------Content---------
    has_many :majorpost
        has_many :artwork
        has_many :link
        has_many :audio
            has_many :audio_image
        has_many :video
            has_many :video_image

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

    #----------------Validation----------------
    #Real Name
    validates :firstname, :presence => true
    validates :lastname, :presence => true

    #Email
    validates :email, :presence => true, format: {with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i}

end