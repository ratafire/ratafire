class LikedUser < ActiveRecord::Base

    #----------------Utilities----------------

    #--------Track activities--------
    include PublicActivity::Model
    tracked except: [:update, :destroy], 
            owner: ->(controller, model) { controller && controller.current_user }    

	#----------------Relationships----------------
	#Belongs to
	belongs_to :liker, class_name: "User"
	belongs_to :liked, class_name: "User"

end
