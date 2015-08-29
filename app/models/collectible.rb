class Collectible < ActiveRecord::Base
  # attr_accessible :title, :body
	belongs_to :project
	belongs_to :user  

	def self.prefill!(options = {})
		collectible = Collectible.new
		collectible.user_id = options[:user_id]
		collectible.project_id = options[:project_id]
		collectible.facebookpage_id = options[:facebookpage_id]
		collectible.level = options[:level]
		collectible.content = options[:content]
		collectible.save
		collectible
	end
end
