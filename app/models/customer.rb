class Customer < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :user
  has_many :cards, :conditions => {:deleted => nil}

  def self.prefill!(customer, user_id)
  	@customer = Customer.new
    @customer.user_id = user_id
  	@customer.customer_id = customer.id
  	@customer.object = customer.object
  	@customer.livemode = customer.livemode
  	@customer.account_balance = customer.account_balance
  	@customer.default_source = customer.default_source
  	@customer.delinquent = customer.delinquent
  	@customer.email = customer.email
  	@customer.save
  end

end
