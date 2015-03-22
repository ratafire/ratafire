class SubscriptionApplication < ActiveRecord::Base
  attr_accessible :why, :plan, :step, :user_id, :status, :goals_subscribers, :goals_monthly, :goals_project, :collectible, :project_id
  belongs_to :user
  has_one :review

  default_scope order: 'subscription_applications.created_at DESC'  

  #Validations
  validates_length_of :why, :minimum => 200, :message => "Too short", :allow_blank => true, :allow_nil => true
  validates_length_of :why, :maximum => 2500, :message => "Too long", :allow_blank => true, :allow_nil => true
  validates_length_of :plan, :minimum => 20, :message => "Too short", :allow_blank => true, :allow_nil => true
  validates_length_of :plan, :maximum => 500, :message => "Too long", :allow_blank => true, :allow_nil => true
  validates_length_of :collectible, :minimum => 20, :message => "Too short", :allow_blank => true, :allow_nil => true
  validates_length_of :collectible, :maximum => 500, :message => "Too long", :allow_blank => true, :allow_nil => true 
end
