class Secret < ActiveRecord::Base
	attr_accessible :namecode
	belongs_to :user

	validates_presence_of :namecode, :message => "Please enter a secret."
end
