module CommentsHelper

	def link_to_destroy(name, url, fallback_url)
		link_to_function name, "confirm_destroy(this, '#{url}')", :href => fallback_url
	end

end