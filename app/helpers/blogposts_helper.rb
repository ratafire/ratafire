module BlogpostsHelper
    def category(category)
    	case category
    	when "new-features"
    		return "New Features"
    	when "engineering"
    		return "Engineering"
    	when "design"
    		return "Design"
        when "news"
            return "News"
        end
    end	
	
end
