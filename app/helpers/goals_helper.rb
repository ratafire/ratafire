module GoalsHelper

	#get a 0-100 number of the % of goals
	def goals_count a, b
		p = ((a.fdiv(b))*100).round(2)
		return p
	end

	def goals_percentage a, b
		p = (a.fdiv(b))*100
    	p = number_to_percentage(p, :percision => 0, :strip_insignificant_zeros => true)
    	return p
    end

end