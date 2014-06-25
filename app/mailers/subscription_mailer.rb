class SubscriptionMailer < ActionMailer::Base
  default from: "from@example.com"
  include Resque::Mailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.subscription_mailer.transaction_confirmation.subject
  #

  #A Confirmation Email for Subscribers
  def transaction_confirmation(transaction_id)
    @transaction = Transaction.find_by_TransactionId(transaction_id)
    @subscription = Subscription.find_by_id(@transaction.subscription_id)
    @subscriber = User.find(@transaction.subscriber_id)
    @subscribed = User.find(@transaction.subscribed_id)
    #Specific items
    @subscribed_fullname = @subscribed.fullname
    @subscribed_username = @subscribed.username
    @transaction_amount = @transaction.amount
    @subscription_next_billing_date = @subscription.next_billing_date.strftime("%m/%d/%Y")
    @subscriber_username = @subscriber.username
    @transaction_uuid = @transaction.uuid
    mail to: @subscriber.email, subject: "Transaction Confirmation"
  end
end
