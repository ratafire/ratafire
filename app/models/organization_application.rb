class OrganizationApplication < ActiveRecord::Base

	attr_accessible :name, :about, :location, :goal_subscription_amount, :step, :icon

	belongs_to :user
	has_one :video
	has_one :organization_paypal_account

	has_attached_file :icon, :styles => {
		:pageview => "128x128#", :small => "40x40#"
	},:default_url => "/assets/projecticon_:style.jpg",
	:url => "/:class/uploads/:id/:style/:escaped_filename",
	:path => "/:class/uploads/:id/:style/:escaped_filename",
	:storage => :s3

	validates_attachment :icon, 
    :content_type => { :content_type => ["image/jpeg","image/jpg","image/png"]}


  	Paperclip.interpolates :escaped_filename do |attachment, style|
    	attachment.instance.normalized_video_file_name
  	end	

  	def normalized_video_file_name
    	"#{self.id}-#{self.icon_file_name.gsub( /[^a-zA-Z0-9_\.]/, '_')}"
  	end

#--- Validations ---

	#Name
	validates_presence_of :name, :message => "Pick a name."
	validates_length_of :name, :minimum => 3, :message => "Organization name must be at least 3 characters long."
	validates_length_of :name, :maximum => 50, :message => "Organization name is too long (maximum 50)."
	validates_uniqueness_of :name, case_sensitive: false, :message => "This organization name is already taken."

	#About
	validates_presence_of :about, :message => "Please enter a description of the organization."
	validates_length_of :about, :minimum => 3, :message => "Organization description must be at least 3 characters long."
	validates_length_of :name, :maximum => 500, :message => "Organization description is too long (maximum 500)."

	#Location
	validates_presence_of :location, :message => "Please enter a location."

	#Icon
	validates_presence_of :icon, :message => "Please choose an organization icon."

	#goals
	validates :goal_subscription_amount, numericality: {only_integer: true, greater_than_or_equal_to: 540}
end
