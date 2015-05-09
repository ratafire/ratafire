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
    @transaction = Transaction.find_by_TransactionId(transaction_id)
    @subscription = Subscription.find_by_id(@transaction.subscription_id)
    @subscriber = User.find(@transaction.subscriber_id)
    @subscribed = User.find(@transaction.subscribed_id)
    #Specific items
    @subscribed_fullname = @subscribed.fullname
    @subscribed_username = @subscribed.username
    @transaction_amount = @transaction.total
    #@subscription_next_billing_date = @subscription.next_billing_date.strftime("%m/%d/%Y")
    @subscriber_username = @subscriber.username
    @transaction_uuid = @transaction.uuid
    subject = "Payment to "+ @subscribed_fullname+" Receipt"
    mail to: @subscriber.email, subject: subject
  end

  #A Welcome Email for Subscribed - Subscription Only
  def new_subscriber(transaction_id,message_id)
    @transaction = Transaction.find_by_TransactionId(transaction_id)
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
    @transaction = Transaction.find_by_TransactionId(transaction_id)
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
    @subscription = Subscription.find_by_id(@transaction.subscription_id)
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
    @subscription = Subscription.find_by_id(@transaction.subscription_id)
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


end
