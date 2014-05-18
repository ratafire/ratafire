class Majorpost < ActiveRecord::Base
  #friendly id
  extend FriendlyId
  friendly_id :perlink, :use => :slugged

  #track activities
  include PublicActivity::Model
  tracked except: [:update, :destroy], owner: ->(controller, model) { controller && controller.current_user }

  attr_accessible :content, :user_id, :project_id, :title, :tag_list, :m_u_inspirations_attributes, :m_p_inspirations_attributes, :m_m_inspirations_attributes, :m_e_inspirations_attributes, :video_attributes, :artwork_id, :published, :perlink, :video_id, :excerpt
  belongs_to :user
  belongs_to :project
  has_many :comments, dependent: :destroy
  has_many :postimages, dependent: :destroy
  has_many :blogposts, dependent: :destroy
  has_one :video, dependent: :destroy
  has_one :artwork, dependent: :destroy
  has_one :archive
  accepts_nested_attributes_for :video, :allow_destroy => true

  #--- Inspiration ---
  #majorpost_user_inspirations
  has_many :m_u_inspirations, foreign_key: "inspired_id", class_name: "M_U_Inspiration", dependent: :destroy
  has_many :user_inspirers, through: :m_u_inspirations, source: :inspirer
  accepts_nested_attributes_for :m_u_inspirations, :allow_destroy => true

  #majorpost_project_inspirations
  has_many :p_m_inspirations, foreign_key: "inspirer_id", class_name: "P_M_Inspiration", dependent: :destroy
  has_many :inspired_projects, through: :p_m_inspirations, source: :inspired
  

  has_many :m_p_inspirations, foreign_key: "inspired_id", class_name: "M_P_Inspiration", dependent: :destroy
  has_many :project_inspirers, through: :m_p_inspirations, source: :inspirer  
  accepts_nested_attributes_for :m_p_inspirations, :allow_destroy => true

  #majorpost_majorpost_inspirations
  has_many :m_m_inspirations, foreign_key: "inspired_id", class_name: "M_M_Inspiration", dependent: :destroy
  has_many :majorpost_inspirers, through: :m_m_inspirations, source: :inspirer
  accepts_nested_attributes_for :m_m_inspirations, :allow_destroy => true

  has_many :reverse_m_m_inspirations, foreign_key: "inspirer_id", class_name: "M_M_Inspiration", dependent: :destroy
  has_many :inspired_majorposts, through: :reverse_m_m_inspirations, source: :inspired  


  #majorpost_external_inspirations
  has_many :m_e_inspirations, foreign_key: "inspired_id", class_name: "M_E_Inspiration", dependent: :destroy
  accepts_nested_attributes_for :m_e_inspirations, :allow_destroy => true

  #--- likes ---
  has_many :liked_majorposts, class_name: "LikedMajorpost", dependent: :destroy

  default_scope order: 'majorposts.created_at DESC'
  default_scope where(:deleted => false)

  acts_as_taggable

  #--- Validations ---
    #user id
    validates :user_id, presence: true, :on => :create

    #project id
    validates :project_id, presence: true, :on => :create

    #title
    #VALID_TITLE_REGEX = /^[a-z\d\-\:\s]+$/i #alphanumeric, -, or space
    validates_presence_of :title, :message => "'_'"
    #validates_length_of :title, :minimum => 6, :message => "Title must be at least 6 characters long."
    validates_length_of :title, :maximum => 60, :message => "is too long! Maximum 60 characters."
    #validates_format_of :title, with: VALID_TITLE_REGEX, :message => "Alphanumerics, -,: , and space only."
    validates_uniqueness_of :title, :scope => :project_id, :message => "Title repeated."

    #content
    #validates :content, presence:true


end
