class Archive < ActiveRecord::Base
 # attr_accessible :title, :content, :project_id, :majorpost_id, :tag_list

  belongs_to :project
  belongs_to :majorpost
  belongs_to :user
  has_one :artwork
  has_one :video
  has_one :icon

  has_many :archiveimages, dependent: :destroy

  acts_as_taggable
  
end
