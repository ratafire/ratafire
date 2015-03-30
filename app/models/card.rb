class Card < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :user
  belongs_to :customer

  def self.prefill!(customer, user_id, customer_id)
    @card = Card.new
  	@card.user_id = user_id
  	@card.customer_stripe_id = customer.id
    @card.customer_id = customer_id
    @card.card_stripe_id = customer.sources.data.first["id"]
    @card.object = customer.object
  	@card.last4 = customer.sources.data.first["last4"]
  	@card.brand = customer.sources.data.first["brand"]
  	@card.funding = customer.sources.data.first["funding"]
  	@card.exp_month = customer.sources.data.first["exp_month"]
  	@card.exp_year = customer.sources.data.first["exp_year"]
  	@card.fingerprint = customer.sources.data.first["fingerprint"]
  	@card.country = customer.sources.data.first["country"]
  	@card.name = customer.sources.data.first["name"]
  	@card.address_line1 = customer.sources.data.first["address_line1"]
  	@card.address_line2 = customer.sources.data.first["address_line2"]
  	@card.address_city = customer.sources.data.first["address_city"]
  	@card.address_state = customer.sources.data.first["address_state"]
  	@card.address_zip = customer.sources.data.first["address_zip"]
  	@card.address_country = customer.sources.data.first["address_country"]
    @card.cvc_check = customer.sources.data.first["cvc_check"]
    @card.address_line1_check = customer.sources.data.first["address_line1_check"]
    @card.address_zip_check = customer.sources.data.first["address_zip_check"]
    @card.dynamic_last4 = customer.sources.data.first["dynamic_last4"]
  	@card.save
  end
end
