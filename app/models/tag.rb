class Tag < ActsAsTaggableOn::Tag

    #----------------Utilities----------------

    #----------------Relationships----------------
    #Has one
    has_one :tag_image

	#--- Methods --- 

	def self.random(count = 1)
		total_count = self.count

		Array.new(count) do |e|
			offset = rand(total_count)
			Tag.first(:offset => offset)
		end
	end
  
	def self.autocomplete(q)
		q = "%#{q}%"
		where("tags.name LIKE ?", q).order('name ASC').limit(5)
	end
  
	def self.autocomplete_data(q)
		Tag.autocomplete(q).map(&:name)
	end


end