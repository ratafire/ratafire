class Blogpost < ActiveRecord::Base
  attr_accessible :title, :content, :user_id, :published
  belongs_to :user
  extend FriendlyId
  friendly_id :title, :use => :slugged
  default_scope order: 'blogposts.created_at DESC'
end
