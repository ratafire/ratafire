class Project < ActiveRecord::Base
  #friendly id

  extend FriendlyId
  friendly_id :perlink, :use => :slugged

  attr_accessible :tagline, :title, :user_id,:perlink, :about,:published,:complete, :tag_list, :p_u_inspirations_attributes, :p_m_inspirations_attributes, :p_p_inspirations_attributes, :p_e_inspirations_attributes, :artwork_id, :video_id, :icon_id, :goal, :source_code, :edit_permission, :realm
  default_scope order: 'projects.created_at DESC'
  default_scope where(:deleted => false)

  #track activities
  include PublicActivity::Model
  tracked except: [:update, :destroy], owner: ->(controller, model) { controller && controller.current_user }

  #Relationship
  belongs_to :user
  has_many :assigned_projects, dependent: :destroy
  has_many :users, :through => :assigned_projects
  has_many :inviteds
  has_many :bifrosts, dependent: :destroy #for inspirations
  has_many :ibifrosts, dependent: :destroy #for adding contributors
  has_many :abandon_logs #for recording the abandoned times
  belongs_to :creator, :class_name => "User", :foreign_key => :creator_id
  
  has_many :comments
  has_many :project_comments
  has_many :majorposts, dependent: :destroy
  has_many :projectimages, dependent: :destroy
  has_one :video, dependent: :destroy
  has_one :artwork, dependent: :destroy
  has_one :icon, dependent: :destroy
  has_one :audio, dependent: :destroy
  has_many :archives

  #--- Inspiration ---
  #majorpost_project_inspirations
  has_many :m_p_inspirations, foreign_key: "inspirer_id", class_name: "M_P_Inspiration", dependent: :destroy
  has_many :inspired_majorposts, through: :m_p_inspirations, source: :inspired

  has_many :p_m_inspirations, foreign_key: "inspired_id", class_name: "P_M_Inspiration", dependent: :destroy
  has_many :majorpost_inspirers, through: :p_m_inspirations, source: :inspirer  
  accepts_nested_attributes_for :p_m_inspirations, :allow_destroy => true

  #project_user_inspirations
  has_many :p_u_inspirations, foreign_key: "inspired_id", class_name: "P_U_Inspiration", dependent: :destroy
  has_many :user_inspirers, through: :p_u_inspirations, source: :inspirer  
  accepts_nested_attributes_for :p_u_inspirations, :allow_destroy => true

  #project_project_inspirations
  has_many :p_p_inspirations, foreign_key: "inspired_id", class_name: "P_P_Inspiration", dependent: :destroy
  has_many :project_inspirers, through: :p_p_inspirations, source: :inspirer
  accepts_nested_attributes_for :p_p_inspirations, :allow_destroy => true

  has_many :reverse_p_p_inspirations, foreign_key: "inspirer_id", class_name: "P_P_Inspiration", dependent: :destroy
  has_many :inspired_projects, through: :reverse_p_p_inspirations, source: :inspired

  #project_external_inspirations
  has_many :p_e_inspirations, foreign_key: "inspired_id", class_name: "P_E_Inspiration", dependent: :destroy
  accepts_nested_attributes_for :p_e_inspirations, :allow_destroy => true

  acts_as_taggable

#--- Likes ---
  has_many :liked_projects, class_name: "LikedProject", dependent: :destroy  

#--- Validations ---

	#user id
	validates :creator_id, presence: true, :on => :create

	#title
	VALID_TITLE_REGEX = /^[a-z\d\-\:\'\s]+$/i #alphanumeric, -, or space
	validates_presence_of :title, :on => :create, :message => "Title must be there."
	#validates_length_of :title, :minimum => 6, :message => "Title must be at least 6 characters long."
	validates_length_of :title, :maximum => 60, :message => "Title is too long! Maximum 60 characters."
	validates_format_of :title, with: VALID_TITLE_REGEX, :message => "Alphanumerics, -, :, ', and space only."
  validates_uniqueness_of :title, :scope => :creator_id, :message => "You have already created a project under the same name."

	#about
	#validates :about, presence:true

  #tagline
  validates_length_of :tagline, :maximum => 116, :message => "Tagline must be less than 116 characters."
  validates_length_of :tagline, :minimum => 6, :message => "Tagline must be at least 6 characters long."

  #Goal
  validates :goal, numericality: {only_integer: true, greater_than_or_equal_to: 1}

  #Perlink
  VALID_PERLINK_REGEX =  /^[a-z\d\-]+$/i
  validates_format_of :perlink, with: VALID_PERLINK_REGEX, :message => "Alphanumerics, and - only."
  validates_uniqueness_of :perlink, :scope => :creator_id ,case_sensitive: false, :message => "You have used this link."
  validates_length_of :perlink, :minimum => 3, :message => "Length must be >= 3."

#------ Before Save  

  def self.prefill!(options = {})
    @project = Project.new
    begin
      @project.uuid = SecureRandom.random_number(8388608).to_s
    end while Project.find_by_uuid(@project.uuid).present?
    @project.creator_id = options[:user_id]
    @project.title = 'New Project ' + DateTime.now.strftime("%H:%M:%S").to_s
    @project.perlink = @project.uuid.to_s
    @project.tagline = @project.uuid.to_s + " pine nuts on the tree"
    @project.goal = 5
    @project.edit_permission = "free"
    #Mysterious multiple users bug that I only know this way of fixing...
    @project.assigned_projects.each do |as|
      as.destroy
    end
    @project.published = false
    @project.complete = false
    @project.commented_at = Time.now
    @project.save
    @project
  end

private

  def generate_pine_nuts!
    begin
      self.uuid = SecureRandom.random_number(8388608).to_s
    end while Project.find_by_uuid(self.uuid).present?
  end

	
end
