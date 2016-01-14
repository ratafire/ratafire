module Helpers  
  def rating_for(rateable_obj, dimension=nil, options={})                             
 
    if dimension.nil?
      klass = rateable_obj.average
    else             
      klass = rateable_obj.average "#{dimension}"    
    end
    
    if klass.nil?
      avg = 0
    else
      avg = klass.avg
    end

    readonly = options[:readonly]
    if readonly == true then
      readonly = true
    else
      readonly = false
    end 

    star = options[:star] || 5
    
    content_tag :span, "", "data-dimension" => dimension, :class => "star", "data-rating" => avg, 
                          "data-id" => rateable_obj.id, "data-classname" => rateable_obj.class.name,
                          "data-star-count" => star, "data-readonly" => readonly            
    
    
  end

  def rating_for_user(rateable_obj, rating_user, dimension = nil, options = {})
    @object = rateable_obj
    @user = rating_user
    @rating = Rate.find_by_rater_id_and_rateable_id_and_dimension(@user.id, @object.id, dimension)
    stars = @rating ? @rating.stars : 0

    disable_after_rate = options[:disable_after_rate] || false

    readonly = options[:readonly]
    if readonly == true then
      readonly = true
    else
      readonly = false
    end 

    if disable_after_rate
      readonly = current_user.present? ? !rateable_obj.can_rate?(current_user.id, dimension) : true
    end

    content_tag :span, '', "data-dimension" => dimension, :class => "star", "data-rating" => stars,
                "data-id" => rateable_obj.id, "data-classname" => rateable_obj.class.name,
                "data-disable-after-rate" => disable_after_rate,
                "data-readonly" => readonly,
                "data-star-count" => 5
  end 

  def imdb_style_rating_for(rateable_obj,dimension=nil, options = {})
    #TODO: add option to change the star icon
    
    if dimension.nil?
      klass = rateable_obj.average
    else             
      klass = rateable_obj.average "#{dimension}"    
    end

    if klass.nil?
      avg = 0
    else
      avg = klass.avg
    end    
    overall_avg = avg

    content_tag :div, '', :style => "background-image:url('#{image_path('big-star.png')}');width:81px;height:81px;margin-top:10px;" do
        content_tag :p, overall_avg, :style => "position:relative;line-height:85px;text-align:center;"
    end
  end

     
end

class ActionView::Base
  include Helpers
end