class Project < ActiveRecord::Base

	has_many :videos
	has_one :artwork, dependent: :destroy
	has_one :icon, dependent: :destroy
    has_one :audio, dependent: :destroy
	has_many :projectimages, dependent: :destroy 
	has_one :pdf

end