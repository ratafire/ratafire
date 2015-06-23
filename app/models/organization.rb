class Organization < ActiveRecord::Base
	# attr_accessible :title, :body
	has_many :users
	has_one :leader, foreign_key: "organization_leader_id", class_name: "User"

	#Subscriptions
	has_many :subscriptions, foreign_key: "subscribed_organization_id", class_name: "OrganizationSubscription", :conditions => { :deleted_at => nil, :activated => true}
	has_many :subscribers, through: :subscriptions, source: :subscriber, :conditions => { :subscriptions => { :deleted_at => nil, :activated => true}}

end
