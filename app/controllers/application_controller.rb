class ApplicationController < ActionController::Base
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :exception

    #Before filters
    before_filter :set_locale
    #After filters
	# Devise login location remember
	after_filter :store_location

  	def store_location
    	# store last url - this is needed for post-login redirect to whatever the user last visited.
    	return unless request.get? 
    	if (request.path != "/users/sign_in" &&
        	request.path != "/users/sign_up" &&
        	request.path != "/users/password/new" &&
        	request.path != "/users/password/edit" &&
        	request.path != "/users/confirmation" &&
        	request.path != "/users/sign_out" &&
        	!request.xhr?) # don't store ajax calls
      		session[:previous_url] = request.fullpath 
    	end
  	end
  	def after_sign_in_path_for(resource)
    	session[:previous_url] || root_path
  	end	
    #Include current_user in PublichActivities
    include PublicActivity::StoreController

private

    def set_locale
        if current_user && current_user.try(:locale)
            unless I18n.locale == current_user.locale
                I18n.locale = current_user.locale
                cookies['locale'] = current_user.locale
            end
        else
            if language_change_necessary?
                I18n.locale = the_new_locale
                set_locale_cookie(I18n.locale)
            else
                use_locale_from_cookie
            end
        end    
    end

    # A locale change is necessary if no locale cookie is found, or if the locale param has been specified
    def language_change_necessary?
        return cookies['locale'].nil?
    end

    # The new locale is taken from the current_user language setting, it logged_in, or from the http accept language header if not
    # In both cases, if a locale param has been passed, it takes precedence. Only available locales are accepted
    def the_new_locale
        new_locale = (extract_locale_from_accept_language_header)
        ['zh', 'en'].include?(new_locale) ? new_locale : I18n.default_locale.to_s
    end

    # Sets the locale cookie
    def set_locale_cookie(locale)
        cookies['locale'] = locale.to_s
    end

    # Reads the locale cookie and sets the locale from it
    def use_locale_from_cookie
        I18n.locale = cookies['locale']
    end

    # Extracts the locale from the accept language header, if found
    def extract_locale_from_accept_language_header
        locale = request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first rescue I18n.default_locale
    end    

end
