class Order < ActiveRecord::Base

    #----------------Utilities----------------

    #Generate uuid
    before_validation :generate_uuid!, :on => :create

    #----------------Relationships----------------
    #Has many
    has_many :order_subsets,
        -> { where(order_subsets:{:deleted_at => nil, :transacted => nil})}
    belongs_to :user

    #----------------Methods----------------

    #--------Send order confirmation--------

    def self.send_confirmation(order_id,subscriber_id)
        #Load models
        @order = Order.find(order_id)
        @subscriber = User.find(subscriber_id)
        #Send order email
        Payment::OrdersMailer.send_confirmation(order_id: @order.id).deliver_now
        #Send order notification
        Notification.create(
            user_id: @subscriber.id,
            trackable_id: @order.id,
            trackable_type: "Order",
            notification_type: "send_order_confirmation"
        )
        #Set order as sent
        @order.update(
            status: 'Sent'
        )
    rescue
    end    

private

    def generate_uuid!
        begin
            self.uuid = SecureRandom.hex(8)
        end while Order.find_by_uuid(self.uuid).present?
    end

end