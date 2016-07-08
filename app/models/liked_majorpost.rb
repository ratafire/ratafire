class LikedMajorpost < ActiveRecord::Base

    #----------------Utilities----------------

    #--------Track activities--------
    include PublicActivity::Model
    tracked except: [:update, :destroy], 
            owner: ->(controller, model) { controller && controller.current_user }    

	#----------------Relationships----------------
	#Belongs to
	belongs_to :user
	belongs_to :majorpost

end
