class SubscriptionsController < ApplicationController
	layout 'application'
	before_filter :signed_in_user,
				  only: [:new,:create,:destroy,:unsub,:amazon]
	before_filter :not_subscribed,
				  only: [:new,:amazon]
	before_filter :subscription_permission,
				  only: [:new, :create, :amazon]
	before_filter :correct_user, only: [:settings, :transactions, :receiving_transactions,:transaction_details]


	def subscribers
		@user = User.find(params[:id])
		@subscribers = @user.subscribers.paginate(page: params[:subscribers], :per_page =>32)
		@project = @user.projects.where(:published => true, :complete => false, :abandoned => false).first
		@message = Message.new
		@subscription_application = @user.approved_subscription_application
	end

	def subscribers_past
		@user = User.find(params[:id])
		@subscribers = @user.past_subscribers.paginate(page: params[:subscribers], :per_page => 32)
	end

	def subscribing
		@user = User.find(params[:id])
		@subscribing = @user.subscribed.paginate(page: params[:subscribing], :per_page =>32)
		@message = Message.new
	end

	def subscribing_past
		@user = User.find(params[:id])
		@subscribing = @user.past_subscribed.paginate(page: params[:subscribing], :per_page => 32)
	end

	def new
		@user = User.find(params[:id])
		@current_user = current_user
		@subscription = Subscription.new
	end	

	def create
		@subscription = Subscription.new(params[:subscription])
		#See if it is a support
		if @subscription.amount == ENV["PRICE_1"].to_f
			@subscription.supporter_switch = true
		end
		@user = User.find(params[:id])
		@subscriber = User.find(@subscription.subscriber_id)
		@subscription.project_id = @user.projects.where(:published => true, :complete => false).first.id
		unless @user.subscribed_by?(@subscriber) || @subscriber.subscribed_by?(@user) then
			if @subscription.save
				@amazon_recurring = AmazonRecurring.prefill!(
					:subscription_id => @subscription.id, 
					:transactionAmount => @subscription.amount.to_s,
					:recipientToken => @user.amazon_recipient.tokenID)
				@subscription.uuid = @amazon_recurring.uuid
				@subscription.save
				port = Rails.env.production? ? "" : ":3000"
				callback_url = "#{request.scheme}://#{request.host}#{port}/r/subscriptions/amazon_payments/subscribe/post_subscribe"
				payment_reason = "Monthly subscription to "+@user.fullname+" to support "+@user.fullname+"'s projects."
				#Create a recurring pipeline with Amazon
				redirect_to AmazonFlexPay.recurring_pipeline(@amazon_recurring.uuid, callback_url,
					:transaction_amount => @amazon_recurring.transactionAmount,
					:recipient_token => @amazon_recurring.recipientToken,
					:recurring_period => @amazon_recurring.recurringPeriod,
					:payment_reason => payment_reason)
			else
				redirect_to(:back)
			end
		else
			redirect_to(@user)
		end	
	end

	def why
		@user = User.find(params[:id])
		@project = @user.projects.where(:published => true, :complete => false, :abandoned => false).first
		@subscription_application = @user.approved_subscription_application
	end

	def amazon
		@user = User.find(params[:id])
	end	

	def settings
		@user = User.find(params[:id])
		if @user.subscription_status_initial != "Approved" then
			redirect_to setup_subscription_path(@user.id)
		else
			@project = @user.projects.where(:published => true, :complete => false, :abandoned => false).first
		end
	end

	def payment_settings
		@user = User.find(params[:id])
	end

	def transactions
		balance = @user.subscription_amount - @user.subscribing_amount
		if balance < 0 then
			balance = 0 - balance
			@balance = "-$"+balance.to_s
		else
			@balance = "$"+balance.to_s
		end
	end

	def receiving_transactions
		respond_to do |format|
    		format.html
    		format.json { render json: ReceivingTransactionsDatatable.new(view_context) }
  		end			
	end

	def paying_transactions
		respond_to do |format|
    		format.html
    		format.json { render json: PayingTransactionsDatatable.new(view_context) }
  		end			
	end	

	def transaction_details
		@transaction = Transaction.find(params[:transaction_id])
		@user = User.find(params[:id])
		if @transaction != nil then
			@subscriber = User.find(@transaction.subscriber_id)
			@subscribed = User.find(@transaction.subscribed_id)
			@amazon = amazon(@transaction.amazon)
			@ratafire = ratafire(@transaction.ratafire_fee)
			@receive = receive(@transaction.receive)
		else
			flash[:success] = "Cannot find transaction."
			redirect_to(:back)
		end
	end

	def turnon
		@user = User.find(params[:id])
		@user.subscription_switch = true
		if @user.save then
			redirect_to(:back)
		else
			redirect_to(:back)
			flash[:success] = "Check your To Subscribers and Intended Update Frequency or Plans."
		end
	end

	def turnoff
		@user = User.find(params[:id])
		@user.subscription_switch = false
		if @user.save then
			render nothing: true
		else
			redirect_to(:back)
			flash[:success] = "Check your To Subscribers and Intended Update Frequency or Plans."
		end
	end

	def destroy
		@subscription = Subscription.find_by_subscriber_id_and_subscribed_id(params[:subscriber_id],params[:id])
		@user = User.find(@subscription.subscriber_id)
		@subscriber = @user
		#Cancel Amazon Payments Token
		response = AmazonFlexPay.cancel_token(@subscription.amazon_recurring.tokenID)
		@subscription.deleted_reason = 2
		@subscription.deleted_at = Time.now
		@subscription.next_transaction_queued = false
		@subscription.save	
		#Mark Subscription Records as having pasts
		@subscription_record = SubscriptionRecord.find(@subscription.subscription_record_id)
		@subscription_record.past = true
		if @subscription_record.duration == nil then
			@subscription_record.duration = @subscription.deleted_at - @subscription.created_at
		else
			duration = @subscription.deleted_at - @subscription.created_at
			@subscription_record.duration = @subscription_record.duration + duration
		end
		@subscription_record.save		
		#destroy activities as well if accumulated total is 0
		valid_subscription = ((@subscription.deleted_at - @subscription.created_at)/1.day).to_i
		if @subscription.accumulated_total == nil || @subscription.accumulated_total == 0 || valid_subscription < 30 then
			PublicActivity::Activity.find_all_by_trackable_id_and_trackable_type(@subscription.id,'Subscription').each do |activity|
				if activity != nil then 
					activity.deleted = true
					activity.deleted_at = Time.now
					activity.save
				end
			end
		end	
		#Remove Enqueued Transaction
		Resque.remove_delayed(SubscriptionNowWorker, @subscription.uuid)		
			#Add to User's Subscription amount
			@subscribed = User.find(@subscription.subscribed_id)
			case @subscription.amount
  			when ENV["PRICE_1"].to_f
  				@subscribed.subscription_amount = @subscribed.subscription_amount - ENV["PRICE_1_RECEIVE"].to_f
  				@subscriber.subscribing_amount = @subscriber.subscribing_amount - ENV["PRICE_1"].to_f
  			when ENV["PRICE_2"].to_f
  				@subscribed.subscription_amount = @subscribed.subscription_amount - ENV["PRICE_2_RECEIVE"].to_f
  				@subscriber.subscribing_amount = @subscriber.subscribing_amount - ENV["PRICE_2"].to_f
  			when ENV["PRICE_3"].to_f
  				@subscribed.subscription_amount = @subscribed.subscription_amount - ENV["PRICE_3_RECEIVE"].to_f
  				@subscriber.subscribing_amount = @subscriber.subscribing_amount - ENV["PRICE_3"].to_f
  			when ENV["PRICE_4"].to_f
 	 			@subscribed.subscription_amount = @subscribed.subscription_amount - ENV["PRICE_4_RECEIVE"].to_f
 	 			@subscriber.subscribing_amount = @subscriber.subscribing_amount - ENV["PRICE_4"].to_f
  			when ENV["PRICE_5"].to_f
 	 			@subscribed.subscription_amount = @subscribed.subscription_amount - ENV["PRICE_5_RECEIVE"].to_f
 	 			@subscriber.subscribing_amount = @subscriber.subscribing_amount - ENV["PRICE_5"].to_f
 	 		when ENV["PRICE_6"].to_f
	  			@subscribed.subscription_amount = @subscribed.subscription_amount - ENV["PRICE_6_RECEIVE"].to_f
	  			@subscriber.subscribing_amount = @subscriber.subscribing_amount - ENV["PRICE_6"].to_f
 	 		end	
 	 		@subscribed.save
 	 		@subscriber.save		
		flash[:success] = "You removed "+@user.fullname+"!"
		redirect_to(:back)
	end

	def unsub
		@subscription = Subscription.find_by_subscriber_id_and_subscribed_id(params[:id],params[:subscribed_id])
		@user = User.find(@subscription.subscribed_id)
		@subscribed = @user
		@subscriber = User.find(@subscription.subscriber_id)
		#Cancel Amazon Payments Token
		response = AmazonFlexPay.cancel_token(@subscription.amazon_recurring.tokenID)
		@subscription.deleted_reason = 1
		@subscription.deleted = true
		@subscription.deleted_at = Time.now
		@subscription.next_transaction_queued = false
		@subscription.save
		#Mark Subscription Records as having pasts
		@subscription_record = SubscriptionRecord.find(@subscription.subscription_record_id)
		@subscription_record.past = true
		if @subscription_record.duration == nil then
			@subscription_record.duration = @subscription.deleted_at - @subscription.created_at
		else
			duration = @subscription.deleted_at - @subscription.created_at
			@subscription_record.duration = @subscription_record.duration + duration
		end				
		@subscription_record.save
		#destroy activities as well if accumulated total is 0
		valid_subscription = ((@subscription.deleted_at - @subscription.created_at)/1.day).to_i
		if @subscription.accumulated_total == nil || @subscription.accumulated_total == 0 || valid_subscription < 30 then
			PublicActivity::Activity.find_all_by_trackable_id_and_trackable_type(@subscription.id,'Subscription').each do |activity|
				if activity != nil then 
					activity.deleted = true
					activity.deleted_at = Time.now
					activity.save
				end
			end
		end		
		#Remove Enqueued Transaction
		Resque.remove_delayed(SubscriptionNowWorker, @subscription.uuid)
		#Change User's subscription amount
			case @subscription.amount
  			when ENV["PRICE_1"].to_f
  				@subscribed.subscription_amount = @subscribed.subscription_amount - ENV["PRICE_1_RECEIVE"].to_f
  				@subscriber.subscribing_amount = @subscriber.subscribing_amount - ENV["PRICE_1"].to_f
  			when ENV["PRICE_2"].to_f
  				@subscribed.subscription_amount = @subscribed.subscription_amount - ENV["PRICE_2_RECEIVE"].to_f
  				@subscriber.subscribing_amount = @subscriber.subscribing_amount - ENV["PRICE_2"].to_f
  			when ENV["PRICE_3"].to_f
  				@subscribed.subscription_amount = @subscribed.subscription_amount - ENV["PRICE_3_RECEIVE"].to_f
  				@subscriber.subscribing_amount = @subscriber.subscribing_amount - ENV["PRICE_3"].to_f
  			when ENV["PRICE_4"].to_f
 	 			@subscribed.subscription_amount = @subscribed.subscription_amount - ENV["PRICE_4_RECEIVE"].to_f
 	 			@subscriber.subscribing_amount = @subscriber.subscribing_amount - ENV["PRICE_4"].to_f
  			when ENV["PRICE_5"].to_f
 	 			@subscribed.subscription_amount = @subscribed.subscription_amount - ENV["PRICE_5_RECEIVE"].to_f
 	 			@subscriber.subscribing_amount = @subscriber.subscribing_amount - ENV["PRICE_5"].to_f
 	 		when ENV["PRICE_6"].to_f
	  			@subscribed.subscription_amount = @subscribed.subscription_amount - ENV["PRICE_6_RECEIVE"].to_f
	  			@subscriber.subscribing_amount = @subscriber.subscribing_amount - ENV["PRICE_6"].to_f
 	 		end	
 	 		@subscribed.save
 	 		@subscriber.save	
		flash[:success] = "You unsubscribed from "+@user.fullname+"!"
		redirect_to(:back)
	end

	def refund
		transaction = Transaction.find_by_uuid(params[:uuid])
		AmazonFlexPay.refund(
			transaction.TransactionId,
			transaction.uuid
		)
		transaction.status = "Refunded"
		transaction.save
		#Resque.enqueue_in(2.minute,RefundStatusWorker, :transaction_id => transaction.TransactionId)
		redirect_to(:back)
		user = User.find(transaction.subscriber_id)
		flash[:success] = "You refunded "+user.fullname+"!"
	end



private
	
	#See if the user is signed in?
    def signed_in_user
      unless signed_in?
        redirect_to new_user_session_path, notice:"Please sign in." unless signed_in?
      end
    end	

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end    

   #Devise 
    def current_user?(user)
      user == current_user
    end   

    #See if the user is in a subscription
    def not_subscribed
    	@user = User.find(params[:id])
    	if @user.subscribed_by?(current_user) || current_user.subscribed_by?(@user) then
    		redirect_to @user
    	else
    		if @user.supported_by?(current_user) || current_user.supported_by?(@user) then
    			redirect_to @user
    		end
    	end
    end	

    #See if the subscription is permitted
    def subscription_permission
    	@subscribed = User.find(params[:id])
    	@subscriber = current_user
    	if Rails.env.production? then
    		#Check History to see if the last subscription is within one month
    		if subscription_permission_30days then
    			redirect_to(:back)
    		else
        		#Check if the subscribed has opened subscription
    			if subscription_permission_opened?	then
    				redirect_to(:back)
    			else
    				#Check if the subscription is approved
    				if subscription_status_initial? then
    					redirect_to(:back)
    				else
    					#Check if the subscribed does not have a subscription note
    					if subscription_permission_note? then
    						redirect_to(:back)
    					else
    						#Check if the subscribed has an on going project
    						if subscription_permission_project? then
    							redirect_to(:back)
    						else
    							#Check if the subscribed is banned
    							if subscription_permission_subscribed_banned? then
    								redirect_to(:back)
    							else
    								#Check if the subscriber is banned
    								if subscription_permission_subscriber_banned? then
	    								redirect_to(:back)
	    							else
	    								#Check if the subscribed reached her goal
	    								if subscription_maximum_amount? then
	    									redirect_to(:back)
	    								#Check if the subscriber is ok to subscribe
	    								else
	    									if subscriber_status? then
	    										redirect_to(:back)
	    									else
	    										if exceed_supporters? then
	    											redirect_to(:back)
	    										end
	    									end
	    								end
    								end
    							end
    						end
    					end
    				end
    			end
    		end
    	else
    		
    	end
    end	

    def subscription_permission_30days 
    	#Check History to see if the last subscription is within one month
    		if Subscription.find_by_subscriber_id_and_subscribed_id(@subscriber.id,@subscribed.id) != nil then
    			@history = Subscription.find_by_subscriber_id_and_subscribed_id(@subscriber.id,@subscribed.id).class.where(:deleted => true).first
    			if @history != nil then
    				@days = ((Time.now - @history.deleted_at)/1.day).round
    				if @days <= 30 then
    					@indays = 30-@days
    					flash[:success] = "Your previous subscription to "+@subscribed.fullname+" ended "+@days.to_s+" days ago. You may subscribe to "+ @subscribed.fullname+" again in "+@indays.to_s+" days."
    					return true
   	 				end
    			end    	
    		end	
    	return false
    end	

    def subscription_status_initial?
    	#Check if the subscription is approved
    	if 1 == 1 then
    		flash[:success] = "We are updating our payment system. Please come back in a week!"
    		return true
    	end
    	return false
    end

    def subscription_permission_opened?
    	#Check if the subscribed has opened subscription
    	if @subscribed.subscription_switch != true || @subscribed.amazon_authorized != true then
    		flash[:success] = "You cannot subscribe to "+@subscribed.fullname+", because "+@subscribed.fullname+" did not setup subscription."
    		return true
    	end
    	return false
    end	

    def subscription_permission_note?
		#Check if the subscribed does not have a subscription note
    	if @subscribed.why == nil || @subscribed.why == "" || @subscribed.plan == nil || @subscribed.plan == "" then
    		flash[:success] = "You cannot subscribe to "+@subscribed.fullname+", because "+@subscribed.fullname+" doesn't have a message to subscribers or an intended update plan."
    		return true
    	end
    	return false
    end	

    def subscription_permission_project?
    	#Check if the subscribed has an on going project
    	if @subscribed.projects.where(:published => true, :complete => false, :abandoned => false).first == nil then
    		flash[:success] = "You cannot subscribe to "+@subscribed.fullname+", because "+@subscribed.fullname+" does not have an ongoing project."
    		return true
    	end
    	return false
    end	   

    def subscription_permission_subscribed_banned?
    	#Check if the subscribed is banned
    	if @subscribed.subscribed_permission == "frozen" then
    		flash[:success] = "You cannot subscribe to "+@subscribed.fullname+", because "+@subscribed.fullname+"'s account is frozen due to violations of Ratafire's rules."
    		return true
    	end
    	return false
    end 	

    def subscription_permission_subscriber_banned?
    	#Check if the subscriber is banned
    	if @subscriber.subscriber_permission == "frozen" then
    		flash[:success] = "You cannot subscribe to "+@subscribed.fullname+", because your account is frozen due to violations of Ratafire's rules."
    		return true
    	end	
    	return false
    end	

    def subscription_maximum_amount?
    	#Check if the subscribed reached her goal
    	if @subscribed.subscription_amount > @subscribed.goals_monthly then
    		flash[:success] = "You cannot subscribe to "+@subscribed.fullname+", because "+@subscribed.fullname+"has reached subscription goal."
    		return true
    	end
    	return false
    end

    def subscriber_status?
		if @subscriber.profilephoto? then
			if @subscriber.github != nil || @subscriber.facebook != nil then
				return false
			else
				flash[:success] = "You cannot subscribe to "+@subscribed.fullname+", because you are not connected to GitHub or Facebook."
				return true
			end
		else
			flash[:success] = "You cannot subscribe to "+@subscribed.fullname+", because you do not have a profile photo."
			return true
		end
	end

	def exceed_supporters?
		if @subscription != nil then
			if @subscriber.supporter_slot <= 0 && @subscription.amount == ENV["PRICE_1"].to_f then
				flash[:success] = "You cannot support "+@subscribed.fullname+", because you do not have enough subscription slots."
				return true
			end
		end
		return false	
	end

  def amazon(amount)
    if amount == nil then
      return "-"
    else
      return "-$"+amount.to_s
    end
  end

  def ratafire(amount)
    if amount == nil then
      return "-"
    else
      return "-$"+amount.to_s
    end
  end

  def receive(amount)
    if amount == nil then
      return "-"
    else
      return "$"+amount.to_s
    end
  end	
end