class Tutorial < ActiveRecord::Base
  attr_accessible :user_id, :profile_tutorial, :project_tutorial
  belongs_to :user
end

#Tutorial List
#:profile_tutorial
#1 => After finding fire
#2 => After changing tagline
#3 => After uploading a profile photo
#4 => After edit about
#5 => After Looking at what others are doing

#:project_tutorial
#1 => After edit title
#2 => After edit tagline
#3 => After edit icon
#4 => After edit tags