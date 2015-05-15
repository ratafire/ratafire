class Batch < ActiveRecord::Base

	require 'date'
	include PublicActivity::Model
	require 'rinku'

	#Update all the facebook updates to the correct format
	def self.update_facebookupdates
		Facebookupdate.where(:valid_update => true).each do |facebookupdate|
			if facebookupdate.description != nil && facebookupdate.message != nil then
				facebookupdate.html_display = facebookupdate.message + " "+facebookupdate.description
				facebookupdate.html_display = Rinku.auto_link(facebookupdate.html_display, :all, 'target="_blank"')
			else
				if facebookupdate.description != nil && facebookupdate.message == nil then
					facebookupdate.html_display = Rinku.auto_link(facebookupdate.description, :all, 'target="_blank"')
				else
					if facebookupdate.message != nil then
						facebookupdate.html_display = Rinku.auto_link(facebookupdate.message, :all, 'target="_blank"')
					end
				end
			end	
			facebookupdate.save	
		end
	end

end