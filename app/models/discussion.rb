class Discussion < ActiveRecord::Base

	extend FriendlyId
	friendly_id :perlink, :use => :slugged

  	attr_accessible :title, :content, :realm, :sub_realm

  	belongs_to :creator, :class_name => "User", :foreign_key => :creator_id
  	has_many :users, :through => :assigned_discussions
  	belongs_to :user

  	has_many :discussion_threads
  	has_many :assigned_discussions

  	acts_as_taggable

 	#title
	VALID_TITLE_REGEX = /^[a-z\d\-\/\:\&\"\'\s]+$/i #alphanumeric, -, ',", or space
	validates_presence_of :title, :on => :create, :message => "Title must be there."
	#validates_length_of :title, :minimum => 6, :message => "Title must be at least 6 characters long."
	validates_length_of :title, :maximum => 60, :message => "Title is too long! Maximum 60 characters."
	validates_format_of :title, with: VALID_TITLE_REGEX, :message => "Alphanumerics, -, :, ',\", &, /, and space only."

#--------- Before Save

	def self.prefill!(options = {})
		@discussion = Discussion.new
		begin
			@discussion.uuid = SecureRandom.random_number(8388608).to_s
		end while Discussion.find_by_uuid(@discussion.uuid).present?
		@discussion.creator_id = options[:user_id]
		@discussion.title = "Untitled New Discussion " + DateTime.now.strftime("%H:%M:%S").to_s
		@discussion.perlink = @discussion.uuid.to_s
		@discussion.edit_permission = "free"
		@discussion.assigned_discussions.each do |as|
			as.destroy
		end
		@discussion.published = false
		@discussion.complete = false
		@discussion.commented_at = Time.now
		@discussion.save
		@discussion
	end

end
