class AbortedFacebookSignupWorker
	@queue = :aborted_facebook_signup

	def self.perform(user_id)
		@user = User.find(user_id)
		if @user != nil then 
			if @user.confirmed_at == nil then
				@user.destroy
			end
		end
	end
end