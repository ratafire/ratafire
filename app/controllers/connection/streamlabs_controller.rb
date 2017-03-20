class Connection::StreamlabsController < ApplicationController

	layout 'profile'

	require 'oauth2'

	#Before filters

	#REST Methods -----------------------------------

	# connection_streamlabs POST
	# /connection/streamlabs
	def create
		unless current_user.streamlab
			if Rails.env.production?
				redirect_to 'https://streamlabs.com/api/v1.0/authorize?client_id='+ENV['STREAMLABS_CLIENT_ID']+"&redirect_uri="+get_redirect_uri+"&response_type=code&scope=donations.create+alerts.create"
			else
				redirect_to 'https://streamlabs.com/api/v1.0/authorize?client_id='+ENV['STREAMLABS_TEST_CLIENT_ID']+"&redirect_uri="+get_redirect_uri+"&response_type=code&scope=donations.create+alerts.create"
			end
		else
			redirect_to(:back)
		end
	rescue
		flash[:error] = t('errors.messages.not_saved')
		redirect_to(:back)
	end

	# connection_streamlabs DELETE
	# /connection/streamlabs
	def destroy
		if streamlab = current_user.try(:streamlab)
			streamlab.update(
				deleted: true,
				deleted_at: Time.now
			)
		end
		redirect_to(:back)
	end

	#NoREST Methods -----------------------------------
	
	# callback_connection_streamlabs GET
	# /connection/streamlabs/callback 
	def callback
		unless current_user.streamlab
			if Rails.env.production?
				query = {
					'grant_type'    => 'authorization_code',
					'client_id'     => ENV['STREAMLABS_CLIENT_ID'],
					'client_secret' => ENV['STREAMLABS_SECRET'],
					'redirect_uri'  => get_redirect_uri,
					'code'          => params[:code]
				}
			else
				query = {
					'grant_type'    => 'authorization_code',
					'client_id'     => ENV['STREAMLABS_TEST_CLIENT_ID'],
					'client_secret' => ENV['STREAMLABS_TEST_SECRET'],
					'redirect_uri'  => get_redirect_uri,
					'code'          => params[:code]
				}
			end
			response = HTTParty.post('https://streamlabs.com/api/v1.0/token', :body => query)
			streamlab = Streamlab.create(
				user_id: current_user.id,
				expires_in: response.parsed_response["expires_in"],
				access_token: response.parsed_response["access_token"],
				refresh_token: response.parsed_response["refresh_token"],
				token_type: response.parsed_response["token_type"]
			)
		end
		redirect_to streaming_settings_user_profile_settings_path(current_user.username)
	rescue
		flash[:error] = t('errors.messages.not_saved')
		redirect_to(:back)		
	end

	def get_redirect_uri
		if Rails.env.production?
			return 'https://ratafire.com/connection/streamlabs/callback'
		else
			return 'http://localhost:3000/connection/streamlabs/callback'
		end
	end

end