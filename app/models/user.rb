require 'elasticsearch/model'

class User < ActiveRecord::Base



    #----------------Utilities----------------

    #Generate uuid
    before_validation :generate_uuid!, :on => :create
    before_create :generate_username, :on => :create    

    #--------Merit--------

    has_merit

    #--------Mailkick--------

    mailkick_user
	
    #--------Devise--------
  	devise :invitable, :database_authenticatable, 
  		:registerable,
        :recoverable, 
        :rememberable, 
        :trackable, 
        :validatable, 
        :confirmable, 
        :omniauthable, 
        :lastseenable,
        :invitable,
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

    #--------Mailboxer--------
    acts_as_messageable

    #--------Friendly id for routing--------
    extend FriendlyId
    friendly_id :uid

    #--------Unread--------
    acts_as_reader

    #--------Profile Photo--------- 
    #Escaped file name for paperclip
    Paperclip.interpolates :escaped_filename2 do |attachment, style|
        attachment.instance.normalized_profile_file_name
    end  
    #Normalized file name for paperclip
    def normalized_profile_file_name
        "#{self.id}-#{self.profilephoto_file_name.gsub( /[^a-zA-Z0-9_\.]/, '_')}"
    end

    #--- Tags ---
    #has_many :followed_tags, foreign_key: "tag_id", class_name: "TagRelationship", dependent: :destroy
    #has_many :tags, through: :saved_tags, source: :tag_followed
    acts_as_tagger
    acts_as_taggable

    #----------------Relationships----------------

    #--------User Info---------
    has_one :profilephoto, foreign_key: "user_uid", primary_key: "uid", class_name: "Profilephoto", dependent: :destroy
    has_one :profilecover, foreign_key: "user_uid", primary_key: "uid", class_name: "Profilecover", dependent: :destroy
    has_one :identity_verification, class_name: "IdentityVerification", dependent: :destroy
    #--------Contacts---------
    

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

    #--------Traits---------
    has_many :trait_relationships, :class_name => 'TraitRelationship'
    has_many :traits, 
        :through => :trait_relationships


    #--------Traits---------
    has_many :achievement_relationships, :class_name => 'AchievementRelationship'
    has_many :achievements, 
        :through => :achievement_relationships

    #--------Followers---------
    has_many :liked_users, foreign_key: "liked_id", class_name: "LikedUser"
    has_many :likers, through: :liked_users, source: :liker, class_name: 'User'

    has_many :reverse_liked_users, foreign_key: "liker_id", class_name: "LikedUser"
    has_many :likeds, through: :reverse_liked_users, source: :liked, class_name: 'User'

    #--------Subscriptions---------
    has_many :subscriptions, 
        -> { where( subscriptions: { :deleted_at => nil, :activated => true, :real_deleted => nil }) },
        foreign_key: "subscribed_id", 
        class_name: "Subscription", 
        dependent: :destroy
    has_many :subscribers, 
        -> { where( subscriptions: { :deleted_at => nil, :activated => true, :real_deleted => nil }) },
        through: :subscriptions, 
        source: :subscriber

    has_many :reverse_subscriptions, 
        -> { where( subscriptions: { :deleted_at => nil, :activated => true, :real_deleted => nil }) },
        foreign_key: "subscriber_id", 
        class_name: "Subscription", 
        dependent: :destroy
    has_many :subscribed, 
        -> { where( subscriptions: { :deleted_at => nil, :activated => true, :real_deleted => nil }) },
        through: :reverse_subscriptions, 
        source: :subscribed

    #--------Payment---------
    has_one :paypal_account,
        -> { where( paypal_accounts: { :deleted_at => nil, :organization_id => nil, :organization_application_id => nil }) }
    has_one :stripe_account
    has_one :customer
    has_one :bank_account
    has_one :card
    has_one :billing_subscription,
        -> { where(billing_subscriptions:{:deleted => nil})}
    has_one :billing_artist, 
        -> { where(billing_artists:{:deleted => nil})}
    has_many :transfers, 
        -> { where(transfers:{:deleted_at => nil})}
    has_many :transfer_transfered,
        -> { where(transfers:{:deleted_at => nil , :transfered => true })},
        class_name: "Transfer", foreign_key: "user_id"
    has_one :hold_transfer,
        -> { where(transfers:{:deleted_at => nil , :transfered => nil, :on_hold => true})},
        class_name: "Transfer", foreign_key: "user_id"
    has_one :order, 
        -> { where(orders:{:deleted_at => nil, :transacted => nil})}
    has_many :transactions, foreign_key: "subscriber_id"
    has_many :shipping_orders,
        -> { where(shipping_orders:{:deleted_at => nil, :transacted => nil})}
    
    #--------Record Backers---------
    has_many :subscription_records, 
        foreign_key: "subscribed_id", 
        class_name: "SubscriptionRecord", 
        dependent: :destroy
    has_many :record_subscribers, 
        -> { where(subscription_records:{:is_valid => true })},    
        through: :subscription_records, 
        source: :subscriber

    has_many :reverse_subscription_records, 
        foreign_key: "subscriber_id", 
        class_name: "SubscriptionRecord", 
        dependent: :destroy
    has_many :record_subscribed, 
        -> { where(subscription_records:{:is_valid => true })},
        through: :reverse_subscription_records, 
        source: :subscribed

    #--------Content---------
    has_many :majorpost,
        -> { where(majorposts:{:deleted_at => nil })}
    has_many :unpaid_updates,
        -> { where(majorposts:{:deleted_at => nil, :paid_update => true, :published => true, :mark_as_paid => false})},
        foreign_key: "user_id",
        class_name: "Majorpost"
    has_many :paid_updates,
        -> { where(majorposts:{:deleted_at => nil, :paid_update => true, :published => true, :mark_as_paid => true})},
        foreign_key: "user_id",
        class_name: "Majorpost"
        has_many :artwork
        has_many :link
        has_many :audio
            has_many :audio_image
        has_many :video
            has_many :video_image

    #--------Campaign---------
    has_many :campaigns
        has_one :active_campaign,
            -> { where( campaigns: { :status => "Approved", :abandoned => nil , :deleted => nil,:deleted_at => nil, :published => true, :completed => nil }) },
            class_name: "Campaign"

    #--------Reward---------
    has_many :rewards
        has_one :active_reward,
        -> { where( rewards: { :active => true })}, class_name: "Reward"
    has_many :shipping_addresses
    has_many :reward_receivers,
        -> { where( reward_receivers: { :deleted => nil })}, class_name: "RewardReceiver"

    #--------Likes---------
    has_many :liked_campaigns
    has_many :liked_majorposts

    #--------Notification---------
    has_many :notifications,
        -> { where( notifications: { :deleted => nil })}, class_name: "Notification"
        has_many :unread_notifications,
        -> { where( notifications: { :is_read => false, :deleted => nil })}, class_name: "Notification"

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
    #--------Weibo---------
    has_one :weibo,
        -> { where( weibos: { :deleted_at => nil}) }
    #--------WeChat---------
    has_one :wechat,
        -> { where( wechats: { :deleted_at => nil}) }
    #--------Renren---------
    has_one :renren,
        -> { where( renrens: { :deleted_at => nil}) }
    #--------Douban---------
    has_one :douban,
        -> { where( doubans: { :deleted_at => nil}) }
    #--------Taobao---------
    has_one :taobao,
        -> { where( taobaos: { :deleted_at => nil}) }
    #--------Baidu---------
    has_one :baidu,
        -> { where( baidus: { :deleted_at => nil}) }
    #--------Streamlab---------
    has_one :streamlab,
        -> { where( streamlabs: { :deleted_at => nil}) }
    has_many :stream_alerts,
        -> { where( streamlabs: { :deleted_at => nil}) }        

    #----------------Admin----------------
    has_many :historical_quotes

    #----------------Translation----------------

    translates :tagline, :fullname, :website, :bio, :job_title ,:firstname, :lastname, :preferred_name, :country, :city, :fallbacks_for_empty_translations => true

    #--------Elastic Search--------
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    #----------------Validation----------------
    #Email
    validates :email, :presence => true, format: {with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i}, uniqueness: { case_sensitive: false }

    #Username
    validates :username, :presence => true, format: {with: /\A(?=.*[a-z])[a-z\d]+\Z/i}, uniqueness: { case_sensitive: false }, length: { in: 3..50 }, on: :update

    #Pass word
    validates :password, length: { in: 6..20 }, :on => :create

    #Real Name
    I18n.locale do |locale|
        validates :"firstname_#{locale}", :presence => true, length: { in: 1..20}
        validates :"lastname_#{locale}", :presence => true, length: { in: 1..20}
    end

    #User Info
    validates :tagline, length: { in: 3..42 }
    validates :website, format: {with: /(^$)|(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/ix}


    #----------------Methods----------------

    #--------Mailboxer--------

    def mailboxer_email(object)
        return "noreply@ratafire.com"
    end

    #--------Subscription--------

    def subscribed_by?(subscriber_id)
        if subscriptions != nil then
            if subscriptions.where(:deleted => false, :activated => true, :subscriber_id => subscriber_id).count != 0 then
                return true
            else
                return false
            end
        else
            return false    
        end
    end    

    #--------Subscription--------

    def is_friend?(friend_id)
        if friends != nil then
            if friendships.where(:friend_id => friend_id).count != 0 
                return true
            else
                return false
            end
        else
            return false
        end
    end    

    def remember_me
        true
    end    

    #--------Scoring--------

    def add_score(event)
        #Add score to @user
        if self.try(:level) <= 59
            case event
            when "quest_sm"
                if level_xp = LevelXp.find(self.level)
                    self.add_points(level_xp.quest_sm, category: 'quest_sm')
                end
            when "quest"
                if level_xp = LevelXp.find(self.level)
                    self.add_points(level_xp.quest, category: 'quest')
                end
            when "quest_lg"
                if level_xp = LevelXp.find(self.level)
                    self.add_points(level_xp.quest_lg, category: 'quest_lg')
                end
            when "ship_reward"
                if level_xp = LevelXp.find(self.level)
                    self.add_points(level_xp.get_backer, category: 'ship_reward')
                end
            end
            #Check level
            i = self.level
            while self.points >= LevelXp.find(i).total_xp_required
                i += 1
                user_real_level = i
            end
            if user_real_level
                if user_real_level > self.level
                    self.update(
                        level: user_real_level
                    )
                    Notification.create(
                        user_id: self.id,
                        trackable_id: self.level,
                        trackable_type: "Level",
                        notification_type: "level_up"
                    )
                    #Check level up achievement
                    Resque.enqueue(Achievement::Level, self.id)
                end
            end
        end
    end

    def remove_score(event)
        if self.level <= 60
            if level_xp = LevelXp.find(self.level)
                case event
                when "quest_sm"
                    self.add_points(-level_xp.quest_sm, category: 'quest_sm')
                when "quest"
                    self.add_points(-level_xp.quest, category: 'quest_sm')
                when "quest_lg"
                    self.add_points(-level_xp.quest_lg, category: 'quest_sm')
                when "ship_reward"
                    if level_xp = LevelXp.find(self.level)
                        self.add_points(-level_xp.get_backer, category: 'ship_reward')
                    end                    
                end
                #Check level
                i = self.level
                unless i == 1
                    while self.points < LevelXp.find(i-1).total_xp_required
                        i -= 1
                        real_level = i
                        if i == 1
                            break
                        end
                    end
                end
                if real_level
                    if real_level < self.level
                        #level down self
                        self.update(
                            level: real_level
                        )
                        #Delete notifications
                        Notification.where(user_id: self.id, notification_type: "level_up").each do |notification|
                            if notification.trackable_id > real_level
                                notification.destroy
                            end
                        end
                    end
                end
            end
        end
    end


private

    def generate_uuid!
        begin
            self.uid = SecureRandom.hex(16)
        end while User.find_by_uid(self.uid).present?
    end

    def generate_username
        begin
            self.username = SecureRandom.hex(5)
        end while User.find_by_username(self.username).present?
    end

end