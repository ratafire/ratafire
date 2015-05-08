class FacebookUpdatesController < ApplicationController

	VERIFY_TOKEN = "mannersmakethman"

	def receive
      	case request.method

	      	when "GET"
	        	challenge = Koala::Facebook::RealtimeUpdates.meet_challenge(params,VERIFY_TOKEN)
	        	if(challenge)
	          		render :text => challenge
	        	else
	          		render :text => 'Failed to authorize facebook challenge request'
	        	end

	      	when "POST"
	        	Facebookupdate.real_time_update!(params)
	        	render :text => 'Thanks for the update.'
	      	end

	end

end