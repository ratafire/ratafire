module AmazonFlexPay::Pipelines #:nodoc:
  class Recurring < Base #:nodoc:
    attribute :amount_type, :enumeration => :amount_type
    attribute :transaction_amount #required
    attribute :currency_code, :enumeration => :currency_code
    attribute :payment_method, :enumeration => :payment_method
    attribute :payment_reason
    attribute :is_recipient_cobranding
    attribute :recipient_token #required
    attribute :recurring_period #required
    attribute :validity_expiry
    attribute :validity_start
    attribute :collect_shipping_address
    attribute :address_name
    attribute :address_line1
    attribute :address_line2
    attribute :city
    attribute :state
    attribute :zip
    attribute :phone_number
    attribute :disable_guest
  end
end
