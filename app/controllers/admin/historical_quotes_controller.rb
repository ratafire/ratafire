class Admin::HistoricalQuotesController < ApplicationController

	layout 'profile'

	protect_from_forgery :except => [:create]

	#Before filters
	before_filter :load_user, except:[:index, :edit, :update]
	before_filter :load_historical_quote, only:[:update, :edit]
	before_filter :is_admin?

	#REST Methods -----------------------------------

	#index_admin_historical_quotes GET
	#/admin/historical_quotes/index
	def index
		respond_to do |format|
			format.html
			format.json { render json: HistoricalQuotesDatatable.new(view_context) }
		end
	end

	#user_admin_historical_quotes POST
	#/users/:user_id/admin/historical_quotes
	def create
		@historical_quotes = current_user.historical_quotes.create(historical_quote_params)
		redirect_to :back
	end

	#update_admin_historical_quotes PATCH
	#/admin/historical_quotes/:id
	def update
		@historical_quote.update(historical_quote_params)
		redirect_to :back
	end

	#edit_admin_historical_quotes GET
	#/admin/historical_quotes/:id
	def edit
	end

	#user_admin_historical_quotes POST
	#/users/:user_id/admin/historical_quotes
	def show
		@historical_quote = HistoricalQuote.new
	end

	#user_admin_historical_quotes DELETE 
	#/users/:user_id/admin/historical_quotes
	def destroy
		if @artwork = Artwork.find_by_uuid(params[:id])
			@artwork.destroy
		end
		render nothing: true
	end

	#NoREST Methods -----------------------------------


private

	def load_user
		#Load user by username due to FriendlyID
		unless @user = User.find_by_uid(params[:user_id])
			unless @user = User.find_by_username(params[:user_id])
				@user = User.find(params[:user_id])
			end
		end
	end	

	def load_historical_quote
		@historical_quote = HistoricalQuote.find(params[:id])
	end

	def historical_quote_params
		params.require(:historical_quote).permit(:user_id,:quote, :author, :source, :chapter, :page, :original_language, :uuid)
	end	

	def is_admin?
		if current_user.admin != true
			redirect_to root_path
		end
	end	

end