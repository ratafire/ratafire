class SecretsController < ApplicationController

	layout 'application'

	before_filter :signed_in_user

	SECRET_LIST = ["chatoyant"]

	def show
		@user = current_user
		@secret = Secret.new
		@secrets = @user.secrets.where(:deleted => nil)
	end

	def enter_secret
		namecode = params[:secret][:namecode].downcase
		@user = User.find(current_user.id)
		if SECRET_LIST.any? { |i| i[namecode] }
			if @user.secrets.find_by_namecode(namecode).present?
				flash[:success] = "You already learned this secret!"
				redirect_to(:back)
			else
				@secret = Secret.new(params[:secret])
				@secret.user_id = current_user.id
				case namecode
				when "chatoyant" 
					@secret.status = "Processing"
					@secret.title = "Free Profile Video"
					@secret.description = "If you live in the greater New York city area, we will help you make your profile video for free, beautifully."
					@secret.mailer_message = "We can help you by shooting your profile fund-raising video with a good camera and a good mic! We will get in touch with you soon."
					@secret.location = "New York"
					@secret.value = "100"
					@secret.category = "promo"
				end
				@secret.save
				#Email the user
				SecretMailer.secret_redeemed(@secret.id).deliver
				#Email the admin
				SecretMailer.video_secret_admin_alert(@secret.id).deliver
				flash[:success] = "You learned a secret!"
				redirect_to(:back)
			end
		else
			flash[:error] = "You entered a wrong secret."
			redirect_to(:back)
		end
	end

private

	def signed_in_user
	  	unless signed_in?
			redirect_to new_user_session_path, notice:"Please sign in." unless signed_in?
	  	end
	end

end