class Video < ActiveRecord::Base
    belongs_to :majorpost
    belongs_to :project	
end