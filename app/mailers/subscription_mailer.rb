class SubscriptionMailer < ActionMailer::Base
  include SendGrid
  default from: "noreply@ratafire.com"
  include Resque::Mailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.subscription_mailer.transaction_confirmation.subject
  #

  #A Receipt Email for Subscribers
  def transaction_confirmation(transaction_id)
    @transaction = Transaction.find(transaction_id)
    @subscription = Subscription.find_by_id(@transaction.subscription_id)
    @subscriber = User.find(@transaction.subscriber_id)
    @subscribed = User.find(@transaction.subscribed_id)
    #Specific items
    @subscribed_fullname = @subscribed.fullname
    @subscribed_username = @subscribed.username
    @transaction_amount = @transaction.total.to_s
    #@subscription_next_billing_date = @subscription.next_billing_date.strftime("%m/%d/%Y")
    @subscriber_username = @subscriber.username
    @transaction_uuid = @transaction.uuid
    subject = "Payment to "+ @subscribed_fullname+" Receipt"
    mail to: @subscriber.email, subject: subject
  end

  #A Welcome Email for Subscribed - Subscription Only
  def new_subscriber(transaction_id,message_id)
    @transaction = Transaction.find(transaction_id)
    @subscription = Subscription.find_by_id(@transaction.subscription_id)
    @subscriber = User.find(@transaction.subscriber_id)
    @subscribed = User.find(@transaction.subscribed_id)   
    #Specific items
    @subscriber_fullname = @subscriber.fullname
    @subscriber_username = @subscriber.username
    @receive_amount = @transaction.receive
    @conversation_id = Mailboxer::Notification.find(message_id).conversation_id
    #@subscription_next_billing_date = @subscription.next_billing_date.strftime("%m/%d/%Y")
    @subscribed_username = @subscribed.username
    @transaction_uuid = @transaction.uuid
    subject = "You have a New Subscriber - "+ @subscriber_fullname
    mail to: @subscribed.email, subject: subject    
  end

  #A Receipt Email for Subscribed - Subscription Only
  def transaction_confirmation_subscribed(transaction_id)
    @transaction = Transaction.find(transaction_id)
    @subscription = Subscription.find_by_id(@transaction.subscription_id)
    @subscriber = User.find(@transaction.subscriber_id)
    @subscribed = User.find(@transaction.subscribed_id)   
    #Specific items
    @subscriber_fullname = @subscriber.fullname
    @subscriber_username = @subscriber.username
    @receive_amount = @transaction.receive
    @subscription_next_billing_date = @subscription.next_billing_date.strftime("%m/%d/%Y")
    @subscribed_username = @subscribed.username
    @transaction_uuid = @transaction.uuid
    subject = "Payment from "+ @subscriber_fullname+" Receipt"
    mail to: @subscribed.email, subject: subject 
  end

  #Send an email to subscriber if transaction fails
  def failed_transaction_retry(transaction_id)
    @transaction = Transaction.find(transaction_id)
    @subscription = Subscription.find(@transaction.subscription_id)
    @subscriber = User.find(@transaction.subscriber_id)
    @subscribed = User.find(@transaction.subscribed_id) 
    #Specific items    
    @subscribed_fullname = @subscribed.fullname
    @subscribed_username = @subscribed.username
    @transaction_amount = @transaction.amount
    @subscription_next_billing_date = Date.tomorrow.strftime("%m/%d/%Y")  
    @subscribed_username = @subscribed.username
    @transaction_uuid = @transaction.uuid
    subject = "Transaction to "+ @subscribed_fullname+" Failed"
    mail to: @subscribed.email, subject: subject      
  end

  #Send an email to subscriber if automatically unsubscribed
  def auto_unsubscribe(transaction_id)
    @transaction = Transaction.find(transaction_id)
    @subscription = Subscription.find(@transaction.subscription_id)
    @subscriber = User.find(@transaction.subscriber_id)
    @subscribed = User.find(@transaction.subscribed_id) 
    #Specific items    
    @subscribed_fullname = @subscribed.fullname
    @subscribed_username = @subscribed.username
    @transaction_amount = @transaction.amount
    @subscription_next_billing_date = Date.tomorrow.strftime("%m/%d/%Y")  
    @subscribed_username = @subscribed.username
    @transaction_uuid = @transaction.uuid
    subject = "Transaction to "+ @subscribed_fullname+" Failed"
    mail to: @subscribed.email, subject: subject      
  end

  #Send an email to subscriber if the payment failed
  def fail_to_process_payment(order_id,failed_method)
    @order = Order.find(order_id)
    if @order != nil then
      @subscriber = User.find(@order.user_id)
      if @subscriber != nil then
        @amount = @order.amount.to_s
        case failed_method
          when "PayPal"
            @failure_message = "Sorry, we can't process your payment through PayPal."
          when "Card"
            @failure_message = "Sorry, we can't process your payment through the card you entered."
          when "no"
            @failure_message = "Sorry, we can't process your payment because you don't have a payment method."
          when "both"
            @failure_message = "Sorry, we can't process your payment through PayPal or the card you entered."
        end
        @due_time = Time.now + 5.days
        subject = "Payment Failure"
        mail to: @subscriber.email, subject: subject
      end
    end
  end

  #Send an email to subscribed who has not updated last month
  def fail_to_update(user_id)
    @user = User.find(user_id)
    @last_month = Time.now - 1.month
    subject = "No Update in " + @last_month.strftime("%B")
    mail to: @user.email, subject: subject
  end

  #Send a final email to subscriber if the payment fails again
  def final_fail_to_process_payment(order_id)
    @order = Order.find(order_id)
    @subscriber = User.find(@order.user_id)
    subject = "Payment Failure"
    mail to: @subscriber.email, subject: subject
  end

  #Send en email the subscriber if the payment is successful
  def successful_order(order_id)
    @order = Order.find(order_id)
    @amount = @order.amount.to_s
    @subscriber = User.find(@order.user_id)
    subject = "Payment Successful"
    mail to: @subscriber.email, subject: subject
  end

end
