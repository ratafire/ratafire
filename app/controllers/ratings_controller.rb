class RatingsController < ApplicationController

	protect_from_forgery :except => [:letsrate]

  def letsrate
  	if Rate.find_by_rater_id_and_rateable_id(current_user.id,params[:id]) == nil then
  		@rate = Rate.new
  		@rate.rater_id = current_user.id
  		@rate.rateable_id = params[:id]
  		@rate.rateable_type = params[:klass]
  		@rate.stars = params[:score]
  		@rate.dimension = params[:dimension]
  		@rate.save
  		update_rate_average("Project",params[:id],0,params[:score],true, params[:dimension])
  	else
  		@rate = Rate.find_by_rater_id_and_rateable_id(current_user.id,params[:id])
  		update_rate_average(@rate.stars,params[:score],false, params[:dimension])
  		@rate.stars = params[:score]
  		@rate.save  		
  	end
  	render :nothing => true
  end

private  

  def update_rate_average(cacheable_type,cacheable_id,prestars,stars,quantity, dimension=nil)
    if RatingCache.find_by_cacheable_type_and_cacheable_id(cacheable_type,cacheable_id) == nil then 
      RatingCache.create do |avg|
        avg.cacheable_id = params[:id]
        avg.cacheable_type = @rate.rateable_type
        avg.avg = stars.to_f
        avg.qty = 1
        avg.dimension = dimension
        #Add to different stars
        case stars.to_f
        when 1.0
        	avg.star_1_qty+=1
        	avg.star_1_per = (avg.star_1_qty/avg.qty)*100
        when 2.0
        	avg.star_2_qty+=1
        	avg.star_2_per = (avg.star_2_qty/avg.qty)*100        	
        when 3.0
        	avg.star_3_qty+=1
        	avg.star_3_per = (avg.star_3_qty/avg.qty)*100         	
        when 4.0
        	avg.star_4_qty+=1
        	avg.star_4_per = (avg.star_4_qty/avg.qty)*100             	
        when 5.0
        	avg.star_5_qty+=1
        	avg.star_5_per = (avg.star_5_qty/avg.qty)*100          	
       	end
        avg.save
      end                     
    else
      a = RatingCache.find_by_cacheable_type_and_cacheable_id(cacheable_type,cacheable_id)
      a.avg = (a.avg + stars.to_f) / (a.qty+1)
      	if quantity == true then
      		a.qty = a.qty + 1
  		  end
        #Add to different stars
        case stars.to_f
        when 1.0
        	a.star_1_qty+=1                             	        	        	
        when 2.0
        	a.star_2_qty+=1       	      	
        when 3.0
        	a.star_3_qty+=1   	             	
        when 4.0
        	a.star_4_qty+=1               	
        when 5.0 	
        	a.star_5_qty+=1             	
       	end   
       	case prestars.to_f
       	when 1.0
        	a.star_1_qty-=1           		
       	when 2.0
        	a.star_2_qty-=1          	     		
       	when 3.0
        	a.star_3_qty-=1          		
       	when 4.0
        	a.star_4_qty-=1       		
       	when 5.0
        	a.star_5_qty-=1           		
       	end 
          a.star_1_per = (a.star_1_qty.to_f/a.qty)*100
          a.star_2_per = (a.star_2_qty.to_f/a.qty)*100         
          a.star_3_per = (a.star_3_qty.to_f/a.qty)*100 
          a.star_4_per = (a.star_4_qty.to_f/a.qty)*100 
          a.star_5_per = (a.star_5_qty.to_f/a.qty)*100             
      a.save
    end   
  end   

  def average(dimension=nil)
    if dimension.nil?
      return "rate_average_without_dimension"
    else
      return "#{dimension}_average"
    end      
  end      

end