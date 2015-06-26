class Organization < ActiveRecord::Base
	# attr_accessible :title, :body
	has_many :users
	belongs_to :leader, class_name: "User", foreign_key: "leader_id"
	has_one :video
	has_one :icon
	has_one :organization_paypal_account

	#Subscriptions
	has_many :subscriptions, foreign_key: "subscribed_organization_id", class_name: "OrganizationSubscription", :conditions => { :deleted_at => nil, :activated => true}
	has_many :subscribers, through: :subscriptions, source: :subscriber, :conditions => { :subscriptions => { :deleted_at => nil, :activated => true}}

end
