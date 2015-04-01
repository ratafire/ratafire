class MessagesController < ApplicationController

	layout 'application'
	before_filter :correct_user

	def inbox
		@user = User.find(params[:id])
		@messages = @user.mailbox.inbox.paginate(page: params[:page], :per_page => 10)
	end

	def show
		@user = User.find(params[:id])
		@conversation = Mailboxer::Conversation.find_by_id(params[:conversation_id])
	    current_user.mark_as_read(@conversation)
        @message = Message.new(params[:message])
    end

	def sent
		@user = User.find(params[:id])
		@messages = @user.mailbox.sentbox.paginate(page: params[:page], :per_page => 10)
    end

	def trash
		@user = User.find(params[:id])
		@messages = @user.mailbox.trash.paginate(page: params[:page], :per_page => 10)
	end

	def settings
		@user = User.find(params[:id])
		@blacklist = @user.blacklisted
	end

	def create
		#Use the fake model of message to get infomation
		@message = Message.new(params[:message])
		#Put the infomation into the real mailbox system
      	if @message.conversation_id
        	@conversation = Mailboxer::Conversation.find_by_id(@message.conversation_id)
        	unless @conversation.is_participant?(current_user)
          		flash[:alert] = "You do not have permission to view that conversation."
          		return redirect_to root_path
        	end
        	receipt = current_user.reply_to_conversation(@conversation, @message.content)
            #if sender is blocked or the participant does not accept new message
            @participant = the_other_participant
            if Blacklist.find_by_blacklister_id_and_blacklisted_id(@participant.id, current_user.id) != nil || @participant.accept_message == false then
                @conversation.mark_as_deleted @participant
            end   
      else
        unless @message.valid?
          return render :new
        end
        @receiver = User.find(@message.receiver_id)
        receipt = current_user.send_message(@receiver, @message.content, @message.title)
        #if sender is blocked or the participant does not accept new message
        if Blacklist.find_by_blacklister_id_and_blacklisted_id(@receiver.id, current_user.id) != nil || @receiver.accept_message == false then
            receipt.conversation.mark_as_deleted @receiver
        end           
      end
      flash[:notice] = "Message sent."
      redirect_to(:back)	
	end

    def trash_message_box
      conversation = Mailboxer::Conversation.find_by_id(params[:conversation_id])
      if conversation
        current_user.trash(conversation)
        flash[:notice] = "Message sent to trash."
      else
        conversations = Mailboxer::Conversation.find(params[:conversations])
        conversations.each { |c| current_user.trash(c) }
        flash[:notice] = "Messages sent to trash."
      end
      redirect_to messaging_inbox_path(params[:id])
    end	

    def trash_message_display
      conversation = Mailboxer::Conversation.find_by_id(params[:conversation_id])
      if conversation
        current_user.trash(conversation)
        flash[:notice] = "Message sent to trash."
      else
        conversations = Mailboxer::Conversation.find(params[:conversations])
        conversations.each { |c| current_user.trash(c) }
        flash[:notice] = "Messages sent to trash."
      end
      redirect_to(:back)
    end     

    def restore
      conversation = Mailboxer::Conversation.find(params[:conversation_id])
      current_user.untrash(conversation)
      flash[:notice] = "Message untrashed."
      redirect_to messaging_trash_path(params[:id])	
    end

    def trash_forever
    	conversation = Mailboxer::Conversation.find(params[:conversation_id])
    	current_user.mark_as_deleted(conversation)
    	flash[:notice] = "Message deleted."
    	redirect_to messaging_trash_path(params[:id])	
    end

    def blacklist
    	blacklister = User.find(params[:id])
    	blacklisted = User.find_by_username(params[:blacklist])
    	if blacklisted != nil then
    		blacklist = Blacklist.new
    		blacklist.blacklister_id = blacklister.id
    		blacklist.blacklisted_id = blacklisted.id
    		blacklist.message = true
    		blacklist.save
    		flash[:success] = "You have blocked "+blacklisted.fullname+" !"
    		redirect_to(:back)
    	else
    		flash[:success] = "Incorrect username."
        redirect_to(:back)
    	end
    end

    def unblock
    	blacklister = User.find(params[:id])
    	blacklisted = User.find(params[:blacklisted_id])
    	blacklist = Blacklist.find_by_blacklister_id_and_blacklisted_id(params[:id], params[:blacklisted_id])
    	if blacklist != nil then
    		blacklist.destroy
    		redirect_to(:back)
    		flash[:success] = "You have unblocked "+blacklisted.fullname+" !"
    	else
    		redirect_to(:back)
    	end  	
    end

    def turnon
    	@user = User.find(params[:id])
    	@user.accept_message = true
    	if @user.save then
    		render nothing: true
    	else
    		redirect_to(:back)
    		flash[:success] = "Unsuccessful."
    	end
    end

    def turnoff
    	@user = User.find(params[:id])
    	@user.accept_message = false
    	if @user.save then
    		render nothing: true
    	else
    		redirect_to(:back)
    		flash[:success] = "Unsuccessful."
    	end    	
    end

private

	def correct_user
	  @user = User.find(params[:id])
	  redirect_to(root_url) unless current_user?(@user)
	end

	def current_user?(user)
	  user == current_user
	end	

    #Find the other participant in @conversation
    def the_other_participant
        if @conversation.participants[0].id == current_user.id then
            return @conversation.participants[1]
        else
            return @conversation.participants[0]
        end
    end

end