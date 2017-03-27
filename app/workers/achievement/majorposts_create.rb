class Achievement::MajorpostsCreate

	@queue = :achievement

	def self.perform(majorpost_id)
		if @majorpost = Majorpost.find(majorpost_id)
			if @user = User.find(@majorpost.user_id)
				#Majorpost count series
				unless @user.achievements.where(name: "Freshly off The Portal").any?
					Resque.enqueue(Achievement::Counter, "Freshly off The Portal", @majorpost.user_id, 1)
				end
				unless @user.achievements.where(name: "Work, Work Never Changes").any?
					Resque.enqueue(Achievement::Counter, "Work, Work Never Changes", @majorpost.user_id, 1)
				end
				unless @user.achievements.where(name: "Full of Potential").any?
					Resque.enqueue(Achievement::Counter, "Full of Potential", @majorpost.user_id, 1)
				end
				unless @user.achievements.where(name: "Brick by Brick").any?
					Resque.enqueue(Achievement::Counter, "Brick by Brick", @majorpost.user_id, 1)
				end
				unless @user.achievements.where(name: "Building a New World").any?
					Resque.enqueue(Achievement::Counter, "Building a New World", @majorpost.user_id, 1)
				end
				unless @user.achievements.where(name: "Persistence is Gold").any?
					Resque.enqueue(Achievement::Counter, "Persistence is Gold", @majorpost.user_id, 1)
				end
				unless @user.achievements.where(name: "Hard Work Maketh Master").any?
					Resque.enqueue(Achievement::Counter, "Hard Work Maketh Master", @majorpost.user_id, 1)
				end
				unless @user.achievements.where(name: "Wolfgang Amadeus Ratafirer").any?
					Resque.enqueue(Achievement::Counter, "Wolfgang Amadeus Ratafirer", @majorpost.user_id, 1)
				end
				#Majorpost analysis
				#Heart of Machine
				if @user.traits.where(trait_name: "Computer Whiz").any?
					heart_of_machine = ['ai','a.i.','machine learning','deep learning','artificial intelligence','人工智能','机器学习','深度学习']
					unless (heart_of_machine & @majorpost.tag_list).empty?
						Resque.enqueue(Achievement::Counter, "Heart of Machine", @majorpost.user_id, 1)
					end
				end
			end
		end
	end	

end