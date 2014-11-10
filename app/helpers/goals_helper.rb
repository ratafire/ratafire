module GoalsHelper

	#get a 0-100 number of the % of goals
	def goals_count a, b
		if a != nil && b != nil then
			p = ((a.fdiv(b))*100).round(2)
			return p
		else
			return 0
		end
	end

	def goals_percentage a, b
		if a != nil && b != nil then
			p = (a.fdiv(b))*100
    		p = number_to_percentage(p, :percision => 0, :strip_insignificant_zeros => true)
    		return p
    	else
    		return 0
    	end
    end

end