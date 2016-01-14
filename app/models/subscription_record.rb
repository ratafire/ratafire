class SubscriptionRecord < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :subscriptions
  has_many :transactions

  belongs_to :past_subscriber, class_name: "User"
  belongs_to :past_subscribed, class_name: "User"

  belongs_to :subscriber, class_name: "User"
  belongs_to :subscribed, class_name: "User"  

  belongs_to :past_supporter, class_name: "User"
  belongs_to :past_supported, class_name: "User"
end
