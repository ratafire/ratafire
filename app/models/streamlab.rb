class Streamlab < ActiveRecord::Base

	belongs_to :user
    has_many :stream_alerts,
        -> { where( streamlabs: { :deleted_at => nil}) }  	

    #Method
    def post_alert(options ={})
    	if user = User.find(self.user_id)
    		I18n.locale = user.locale
    	end
    	#Create alert
    	stream_alert = StreamAlert.create(
    		user_id: self.user_id,
    		streamlab_id: self.id,
    		alert_type: options[:alert_type],
    	)
    	#Refresh token
    	if Rails.env.production?
			refresh_token_query = {
				'grant_type'    => 'refresh_token',
				'client_id'     => ENV['STREAMLABS_CLIENT_ID'],
				'client_secret' => ENV['STREAMLABS_SECRET'],
				'redirect_uri'  => self.streamlab_get_redirect_uri,
				'refresh_token'          => self.refresh_token
			}
		else
			refresh_token_query = {
				'grant_type'    => 'refresh_token',
				'client_id'     => ENV['STREAMLABS_TEST_CLIENT_ID'],
				'client_secret' => ENV['STREAMLABS_TEST_SECRET'],
				'redirect_uri'  => self.streamlab_get_redirect_uri,
				'refresh_token'          => self.refresh_token
			}
		end
		if refresh_token_response = HTTParty.post('https://www.twitchalerts.com/api/v1.0/token', :body => refresh_token_query)
			self.update(
				access_token: refresh_token_response.parsed_response["access_token"],
				refresh_token: refresh_token_response.parsed_response["refresh_token"],
				token_type: refresh_token_response.parsed_response["token_type"]
			)
	    	#Post the alert to Streamlab
	    	case options[:alert_type] 
	    	when 'follow'
	    		#required name, alert_type
				query = {
					'access_token'  => self.access_token,
					'type'          => 'follow',
					'message'       => '*'+options[:name]+'*'+I18n.t('views.profile.settings.streaming_settings.becomes_a_follower')
				}	    		
			when 'donation'
				#required transaction_id, amount, currency, subscriber_id, name, alert_type,email
				stream_alert.update(
					transaction_id: options[:transaction_id],
					amount: options[:amount],
					currency: options[:currency],
					subscriber_id: options[:subscriber_id]
				)
				donation_query = {
					'access_token'  => self.access_token,
					'name'          => options[:name],
					'identifier'	=> options[:email],
					'amount'		=> options[:amount],
					'currency'      => options[:currency]
				}	  
				# Send donation query
				donation_response = HTTParty.post('https://streamlabs.com/api/v1.0/donations', :body => donation_query)	
				query = {
					'access_token'  => self.access_token,
					'type'          => 'follow',
					'message'       => '*'+options[:name]+'*'+I18n.t('views.profile.settings.streaming_settings.backed')+'*'+'$'+options[:amount].to_s+'*'+'!',
				}	 
			when 'subscription'
				#required amount, currency, subscriber_id, subscription_type, name, alert_type
				stream_alert.update(
					amount: options[:amount],
					currency: options[:currency],
					subscriber_id: options[:subscriber_id]
				)
				if options[:subscription_type] == 'per_creation'
					#per creation
					query = {
						'access_token'  => self.access_token,
						'type'          => 'follow',
						'message'       => '*'+options[:name]+'*'+I18n.t('views.profile.settings.streaming_settings.becomes_a_long_term_backer')+'*'+'$'+options[:amount].to_s+'*'+I18n.t('views.payment.backs.per_creation')+'!',
					}
				else
					#per month
					query = {
						'access_token'  => self.access_token,
						'type'          => 'follow',
						'message'       => '*'+options[:name]+'*'+I18n.t('views.profile.settings.streaming_settings.becomes_a_long_term_backer')+'*'+'$'+options[:amount].to_s+'*'+I18n.t('views.payment.backs.per_month')+'!',
					}
				end
			end	
			#Send the api request
			if response = HTTParty.post('https://streamlabs.com/api/v1.0/alerts', :body => query)		
				if response.parsed_response['success'] == true
					stream_alert.update(
						status: 'success'
					)
				end
			end
		end
    end

	def streamlab_get_redirect_uri
		if Rails.env.production?
			return 'https://ratafire.com/connection/streamlabs/callback'
		else
			return 'http://localhost:3000/connection/streamlabs/callback'
		end
	end
	
end
