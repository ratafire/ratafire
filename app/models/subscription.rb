class Subscription < ActiveRecord::Base
  attr_accessible :amount, :subscriber_id, :subscribed_id, :created_at, :supporter, :method

  default_scope order: 'subscriptions.created_at DESC'

  #track activities
  include PublicActivity::Model
  tracked except: [:create, :update, :destroy], owner: ->(controller, model) { controller && controller.current_user }  

  belongs_to :subscriber, class_name: "User"
  belongs_to :subscribed, class_name: "User"
  belongs_to :subscription_record

  belongs_to :supporter, class_name: "User"
  belongs_to :supported, class_name: "User"

  has_one :amazon_recurring

  #Reasons a subscription stopped
  #1. Subscriber unsubscribed
  #2. Subscribed removed the subscriber
  #3. Subscriber failed to make payments
  #4. Subscribed failed to maintain status
  #5. Subscribed deactivated account
  #6. Subscriber deactivated account
  #7. Subscribed changed payments account

  #8. Supported remove the supporter
  #9. Supporter unsupported
  #10. Did not pass the 3 supporters test

  #--- Validations ---

  	#subscriber
  	validates_presence_of :subscriber_id

  	#subscribed
  	validates_presence_of :subscribed_id

  	#amount
  	validates_presence_of :amount
end
