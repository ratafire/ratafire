# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  username   :string(255)
#  fullname   :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ActiveRecord::Base
	#friendly id
	extend FriendlyId
	friendly_id :username

	#Messaging
	acts_as_messageable

  default_scope order: 'users.created_at DESC'

#Environment-specific direct upload url verifier screens for malicious posted upload locations.
  DIRECT_UPLOAD_URL_FORMAT = %r{\Ahttps:\/\/s3\.amazonaws\.com\/Ratafire_#{Rails.env}\/(?<path>uploads\/.+\/(?<filename>.+))\z}.freeze

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # :registerable is currently disabled
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :omniauthable, :omniauth_providers => [:facebook, :twitter, :github, :deviantart, :vimeo]

	#Accessable to outside users, are you sure you want them to change name?
	#Profilelarge is the large profilelarge, profielmedium is the medium profilelarge

	attr_accessible :username, :email, :fullname, :password, :password_confirmation, :current_password, :remember_me, :tagline, :website, :bio, :facebook, :twitter, :github, :deviantart, :vimeo, :profilephoto,:profilephoto_delete, :goals_subscribers, :goals_monthly, :goals_project, :why, :plan, :goals_updated_at, :confirmed_at, :location
	has_attached_file :profilephoto, :styles => { :medium => "128x171#", :small => "128x128#", :small64 => "64x64#", :tiny => "40x40#"}, :default_url => "/assets/usericon_:style.png",
	      :url => ":class/:id/:style/:escaped_filename2",:hash_secret => "longSecretString",
	      :path => ":class/:id/:style/:escaped_filename2",
	      :storage => :s3,
	      :s3_credentials => "#{Rails.root}/config/s3_profile.yml"

	#process_in_background :profilephoto, :only_process => [:small64, :tiny]           

	#profilephoto
	validates_attachment :profilephoto, content_type: { content_type: ["image/jpg", "image/jpeg", "image/png"] }, :size => { :in => 0..1024.kilobytes}

	#Relationship

	has_many :assigned_projects
	has_many :projects, :through => :assigned_projects, :conditions => { :deleted_at => nil }
	has_many :created_projects, :class_name => "Project", :foreign_key => :creator_id

	has_many :majorposts, :conditions => { :deleted_at => nil }
	has_many :archives

	has_many :comments, :conditions => { :deleted_at => nil }

	has_many :inviteds

	has_one :facebook
	has_one :twitter
	has_one :github
	has_one :deviantart
	has_one :vimeo

	#--- Payments ---
	#Subscriptions
	has_many :subscriptions, foreign_key: "subscribed_id", class_name: "Subscription", dependent: :destroy, :conditions => { :deleted_at => nil, :activated => true, :supporter_switch => false }
	has_many :subscribers, through: :subscriptions, source: :subscriber, :conditions => {:subscriptions => {:deleted_at => nil, :activated => true, :supporter_switch => false}}

	has_many :reverse_subscriptions, foreign_key: "subscriber_id", class_name: "Subscription", dependent: :destroy, :conditions => { :deleted_at => nil, :activated => true, :supporter_switch => false }
	has_many :subscribed, through: :reverse_subscriptions, source: :subscribed, :conditions => {:subscriptions => {:deleted_at => nil, :activated => true, :supporter_switch => false}}

	#Supporters
	has_many :supports, foreign_key: "subscribed_id", class_name: "Subscription", dependent: :destroy, :conditions => {:deleted_at => nil, :activated => true, :supporter_switch => true}
	has_many :supporters, through: :supports, source: :subscriber, :conditions => {:subscriptions => {:deleted_at => nil, :activated => true, :supporter_switch => true}}

	has_many :reverse_supports, foreign_key: "subscriber_id", class_name: "Subscription", dependent: :destroy, :conditions => { :deleted_at => nil, :activated => true, :supporter_switch => true }
	has_many :supported, through: :reverse_supports, source: :subscribed, :conditions => {:subscriptions => {:deleted_at => nil, :activated => true, :supporter_switch => true}}

	#Subscription_histories
	has_many :past_subscriptions, foreign_key: "subscribed_id", class_name: "SubscriptionRecord", dependent: :destroy, :conditions => { :past => true }
	has_many :past_subscribers, through: :past_subscriptions, source: :subscriber, :conditions => {:subscription_records => { :past => true, :accumulated => true}}

	has_many :reverse_past_subscriptions, foreign_key: "subscriber_id", class_name: "SubscriptionRecord", dependent: :destroy, :conditions => { :past => true }
	has_many :past_subscribed, through: :reverse_past_subscriptions, source: :subscribed, :conditions => {:subscription_records => { :past => true, :accumulated => true}}

	#Support_histories
	has_many :past_supports, foreign_key: "subscribed_id", class_name: "SubscriptionRecord", dependent: :destroy, :conditions => { :past_support => true }
	has_many :past_supporters, through: :past_supports, source: :subscriber, :conditions => {:subscription_records => { :past_support => true, :accumulated => true}}

	has_many :reverse_past_supports, foreign_key: "subscriber_id", class_name: "SubscriptionRecord", dependent: :destroy, :conditions => {:past_support => true}
	has_many :past_supported, through: :reverse_past_supports, source: :subscribed, :conditions => {:subscription_records => {:past_support => true, :accumulated =>true}}

	#Subscription_records
	has_many :subscription_records, foreign_key: "subscribed_id", class_name: "SubscriptionRecord", dependent: :destroy
	has_many :record_subscribers, through: :subscription_records, source: :subscriber

	has_many :reverse_subscription_records, foreign_key: "subscriber_id", class_name: "SubscriptionRecord", dependent: :destroy
	has_many :record_subscribed, through: :reverse_subscription_records, source: :subscribed

	#--- Blacklist ---
	has_many :blacklist_records, foreign_key: "blacklister_id", class_name: "Blacklist", dependent: :destroy
	has_many :blacklisted, through: :blacklist_records, source: :blacklisted

	has_many :reverse_blacklist_records, foreign_key: "blacklisted_id", class_name: "Blacklist", dependent: :destroy
	has_many :blacklister, through: :reverse_blacklist_records, source: :blacklister

	#Amazon
	has_one :amazon_recipient
	
	#--- Inspiration ---
	#majorpost_user_inspirations
  	has_many :reverse_m_u_inspirations, foreign_key: "inspirer_id",  class_name: "M_U_Inspiration", dependent: :destroy
  	has_many :inspired_majorposts, through: :reverse_m_u_inspirations, source: :inspired

  	#project_user_inspirations
  	has_many :reverse_p_u_inspirations, foreign_key: "inspirer_id", class_name: "P_U_Inspiration", dependent: :destroy
 	has_many :inspired_projects, through: :reverse_p_u_inspirations, source: :inspired  	

	#Downcase the email to ensure its uniqueness
	before_save :downcase_email
	before_save :create_remember_token

  	#--- Tags ---
  	#has_many :followed_tags, foreign_key: "tag_id", class_name: "TagRelationship", dependent: :destroy
  	#has_many :tags, through: :saved_tags, source: :tag_followed
  	acts_as_tagger
  	acts_as_taggable

  	#--- Likes ---
  	has_many :liked_projects, class_name: "LikedProject", dependent: :destroy
  	has_many :liked_majorposts, class_name: "LikedMajorpost", dependent: :destroy
  	has_many :liked_comments, class_name: "LikedComment", dependent: :destroy

  	#has_many :liked_activities, foreign_key: "user_id", class_name: "LikedActivity", dependent: :destroy
  	#has_many :activities, through: :liked_activities, source: :liked_activities

#--- Validations ---

	#username
	VALID_USERNAME_REGEX = /\A[a-zA-Z0-9_]+\z/
	validates_presence_of :username, :message => "Pick a username."
	validates_length_of :username, :minimum => 3, :message => "Username must be at least 3 characters."
	validates_length_of :username, :maximum => 50, :message => "Username is too long (maximum 50)."
	validates_format_of :username, with: VALID_USERNAME_REGEX, :message => "Alphanumerics,and _only."
	validates_uniqueness_of :username, case_sensitive: false, :message => "This username is already taken."

	#email
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates_presence_of :email, :message => "Don't forget your email address."
	validates_format_of :email, with: VALID_EMAIL_REGEX, :message => "Doesn't look like a valid email."
	validates_uniqueness_of :email, case_sensitive: false, :message => "This email is already taken."

	
	#fullname
	validates_presence_of :fullname, :message => "Enter your first and last name."
	validates_length_of :fullname, :minimum => 3, :message => "Name must be at least 3 characters."
	validates_length_of :fullname, :maximum => 50, :message => "Aww, this is such a long name! (maximum 50)"
	
	#password
	validates_presence_of :password, :on => :create, :message => "Enter password."
	
	#tagline,website,bio
	validates :tagline, length: { maximum: 42 }
	validates :tagline, length: { minimum: 3 }
	validates :website, length: { maximum: 100 }
	validates :bio, length: { maximum: 214 }
	validates :location, length: { maximum: 30 }
	
	#social media
	validates :facebook, length: {  maximum: 50 }
	validates :twitter, length: {  maximum: 50 }
	validates :github, length: {  maximum: 50 }
	validates :deviantart, length: {  maximum: 50 }
	validates :vimeo, length: {  maximum: 50 }
  
	#goals
	validates :goals_subscribers, numericality: {only_integer: true, greater_than_or_equal_to: 32}
	validates :goals_monthly, numericality: {only_integer: true, greater_than_or_equal_to: 540}
	validates :goals_project, numericality: {only_integer: true, greater_than_or_equal_to: 1}

	#subscription
	validates_length_of :why, :minimum => 200, :message => "Too short", :allow_blank => true, :allow_nil => true
	validates_length_of :why, :maximum => 2500, :message => "Too long", :allow_blank => true, :allow_nil => true
	validates_length_of :plan, :minimum => 20, :message => "Too short", :allow_blank => true, :allow_nil => true
	validates_length_of :plan, :maximum => 500, :message => "Too long", :allow_blank => true, :allow_nil => true



  def first_name
      split = fullname.split(' ', 2)
      first_name = split.first
      return first_name
  end

  #@user.subscribed_by(current_user) => current_user is subscribing @user
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

  #@user.supported_by(current_user) => current_user is supporting @user
  def supported_by?(supporter_id)
  	if supports != nil then
  		if supports.where(:deleted => false, :activated => true, :subscriber_id => supporter_id).count != 0 then
  			return true
  		else
  			return false
  		end
  	else
  		return false	
  	end
  end

  #Used to find subscription
  def subscription_project_find(subscriber_id, subscribed_id)
  	subscription = Subscription.find_by_subscriber_id_and_subscribed_id(subscriber_id,subscribed_id)
  	return Project.find(subscription.project_id)
  end

  def soft_delete
    update_attribute(:deactivated_at, Time.current)
  end

  def active_for_authentication?
  	super && !deactivated_at
  end

	Paperclip.interpolates :escaped_filename2 do |attachment, style|
		attachment.instance.normalized_profile_file_name
	end  

	def normalized_profile_file_name
		"#{self.id}-#{self.profilephoto_file_name.gsub( /[^a-zA-Z0-9_\.]/, '_')}"
	end

  # Determines if file requires post-processing (image resizing, etc)
  def post_process_required?
    %r{^(image|(x-)?application)/(bmp|gif|jpeg|psd|jpg|pjpeg|png|x-png)$}.match(profilephoto_content_type).present?
  end  	

  # Final upload processing step
  def self.transfer_and_cleanup(id)
    user = User.find(id)
    direct_upload_url_data = DIRECT_UPLOAD_URL_FORMAT.match(user.direct_upload_url)
    s3 = AWS::S3.new
    
    if user.post_process_required?
      user.profilephoto = URI.parse(URI.escape(user.direct_upload_url))
    else
      escaped_file_name = user.profilephoto_file_name.gsub(/[^a-zA-Z0-9_\.]/, '_')
      paperclip_file_path = "profilephoto/uploads/#{id}/original/#{escaped_file_name}"
      s3.buckets[Rails.configuration.aws[:bucket]].objects[paperclip_file_path].copy_from(direct_upload_url_data[:path])
    end
 
    user.processed = true
    user.save
    
    s3.buckets[Rails.configuration.aws[:bucket]].objects[direct_upload_url_data[:path]].delete
  end  	

	#Mailboxer
	def mail_email(object)
		return email
	end

	#Auto Html
  	auto_html_for :bio do
    	html_escape
    	link :target => "_blank", :rel => "nofollow"
  	end	

  def direct_upload_url=(escaped_url)
    write_attribute(:direct_upload_url, (CGI.unescape(escaped_url) rescue nil))
  end

  # Set attachment attributes from the direct upload
  # @note Retry logic handles S3 "eventual consistency" lag.
  def set_upload_attributes
    tries ||= 5
    direct_upload_url_data = DIRECT_UPLOAD_URL_FORMAT.match(self.direct_upload_url)
    s3 = AWS::S3.new
    direct_upload_head = s3.buckets[Rails.configuration.aws[:bucket]].objects[direct_upload_url_data[:path]].head
 
    self.profilephoto_file_name     = direct_upload_url_data[:filename]
    self.profilephoto_file_size     = direct_upload_head.content_length
    self.profilephoto_content_type  = direct_upload_head.content_type
    self.profilephoto_updated_at    = direct_upload_head.last_modified
    self.save
  rescue AWS::S3::Errors::NoSuchKey => e
    tries -= 1
    if tries > 0
      sleep(3)
      retry
    else
      false
    end
  end  

  # Queue file processing
  def queue_processing
    User.transfer_and_cleanup(id)
  end

	private
	
		#Memory Token
		def create_remember_token
			self.remember_token = SecureRandom.urlsafe_base64
		end

		#Downcase Email

		def downcase_email
			if self.email != nil then
				self.email = email.downcase
			end 		 
		end


end
