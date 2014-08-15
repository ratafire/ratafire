class Message < ActiveRecord::Base
	attr_accessible :title, :receiver_id, :content, :conversation_id
	validates_presence_of :title, :message => "Please enter a title."
	validates_presence_of :content, :message => "Content can't be blank."
	validates_length_of :title,:minimum => 1, :message => "Please enter a title."
	validates_length_of :content,:minimum => 1, :message => "Content can't be blank."
end