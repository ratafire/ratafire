class DiscussionThread < ActiveRecord::Base

	extend FriendlyId
	friendly_id :perlink, :use => :slugged

	attr_accessible :title, :content, :creator_id, :discussion_id, :level, :level_2_id, :level_3_id, :level_4_id, :parent_id

  	#track activities
  	#include PublicActivity::Model
  	#tracked except: [:update, :destroy], owner: ->(controller, model) { controller && controller.current_user }  
  
	belongs_to :discussion
	belongs_to :creator, :class_name => "User", :foreign_key => :creator_id
	belongs_to :user

	#Connection Between Level 1 and Level 2
	has_many :level_2_connection, foreign_key: "level_1_id", class_name: "ThreadConnector"
	has_many :level_2, through: :level_2_connection, source: :level_2,:conditions => { :deleted_at => nil}

	has_many :reverse_level_2_connection, foreign_key: "level_2_id", class_name: "ThreadConnector"
	has_many :level_1, through: :reverse_level_2_connection, source: :level_1, :conditions => { :deleted_at => nil}

	#Connection Between Level 2 and Level 3	
	has_many :level_3_connection, foreign_key: "level_2_id", class_name: "ThreadConnector"
	has_many :level_3, through: :level_3_connection, source: :level_3,:conditions => { :deleted_at => nil}

	has_many :reverse_level_3_connection, foreign_key: "level_3_id", class_name: "ThreadConnector"
	has_many :level_23, through: :reverse_level_3_connection, source: :level_2, :conditions => { :deleted_at => nil}

	#Connection Between Level 3 and Level 4	
	has_many :level_4_connection, foreign_key: "level_3_id", class_name: "ThreadConnector"
	has_many :level_4, through: :level_4_connection, source: :level_4,:conditions => { :deleted_at => nil}

	has_many :reverse_level_4_connection, foreign_key: "level_4_id", class_name: "ThreadConnector"
	has_many :level_34, through: :reverse_level_4_connection, source: :level_3, :conditions => { :deleted_at => nil}	

	#Connection Between Level 4 and Level 5	
	has_many :level_5_connection, foreign_key: "level_4_id", class_name: "ThreadConnector"
	has_many :level_5, through: :level_5_connection, source: :level_5,:conditions => { :deleted_at => nil}

	has_many :reverse_level_5_connection, foreign_key: "level_5_id", class_name: "ThreadConnector"
	has_many :level_45, through: :reverse_level_5_connection, source: :level_4, :conditions => { :deleted_at => nil}	

#--------- Before Save
	
	def self.prefill!(options = {})
		begin
			@discussion_thread.uuid = SecureRandom.random_number(8388608).to_s
		end while DiscussionThread.find_by_uuid(@discussion_thread.uuid).present?	
		@discussion_thread.perlink = @discussion_thread.uuid.to_s
		@discussion_thread.edit_permission = "free"
		@discussion_thread.commented_at = Time.now
	end
	
end
