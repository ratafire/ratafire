class Admin::MajorpostsController < ApplicationController

	def set_featured
	end

	def set_homepage_featured
	end

	def set_test
	end

protected

	def load_majorpost
		unless @majorpost = Majorpost.find_by_uuid(params[:id])
			unless @majorpost = Majorpost.find_by_uuid(params[:majorpost_id])
			end
		end
	end

end