class ProjectComment < ActiveRecord::Base
  # attr_accessible :title, :body

  #friendly id
  extend FriendlyId
  friendly_id :id

  include PublicActivity::Model
  tracked except: [:update, :destroy], owner: ->(controller, model) { controller && controller.current_user }

  default_scope where(:deleted => false)

  attr_accessible :content, :user_id, :majorpost_id, :project_id, :excerpt

  has_many :commentimages, dependent: :destroy
  belongs_to :user
  belongs_to :project

#--- Likes ---
  has_many :liked_comments, class_name: "LikedComment", dependent: :destroy  

#--- Validations ---  
	validates :content, presence: true, length: { minimum: 24 }  

end
