# Be sure to restart your server when you modify this file.
#
# 5 stars is a common ranking use case. They are not given at specified
# actions like badges, you should define a cron job to test if ranks are to be
# granted.
#
# +set_rank+ accepts:
# * :+level+ ranking level (greater is better)
# * :+to+ model or scope to check if new rankings apply
# * :+level_name+ attribute name (default is empty and results in 'level'
#   attribute, if set it's appended like 'level_#{level_name}')

module Merit
    class RankRules
        include Merit::RankRulesMethods

        def initialize
            # set_rank :level => 1, :to => Commiter.active do |commiter|
            #   commiter.repositories.count > 1 && commiter.followers >= 10
            # end
            #
            # set_rank :level => 2, :to => Commiter.active do |commiter|
            #   commiter.branches.count > 1 && commiter.followers >= 10
            # end
            #
            # set_rank :level => 3, :to => Commiter.active do |commiter|
            #   commiter.branches.count > 2 && commiter.followers >= 20
            # end
            set_rank level: 2, to: User do |user|
                user.points >= LevelXp.find_by_level(1).total_xp_required
            end
            set_rank level: 3, to: User do |user|
                user.points >= LevelXp.find_by_level(2).total_xp_required
            end          
            set_rank level: 4, to: User do |user|
                user.points >= LevelXp.find_by_level(3).total_xp_required
            end    
            set_rank level: 5, to: User do |user|
                user.points >= LevelXp.find_by_level(4).total_xp_required
            end     
            set_rank level: 6, to: User do |user|
                user.points >= LevelXp.find_by_level(5).total_xp_required
            end    
            set_rank level: 7, to: User do |user|
                user.points >= LevelXp.find_by_level(6).total_xp_required
            end
            set_rank level: 8, to: User do |user|
                user.points >= LevelXp.find_by_level(7).total_xp_required
            end          
            set_rank level: 9, to: User do |user|
                user.points >= LevelXp.find_by_level(8).total_xp_required
            end    
            set_rank level: 10, to: User do |user|
                user.points >= LevelXp.find_by_level(9).total_xp_required
            end     
            set_rank level: 11, to: User do |user|
                user.points >= LevelXp.find_by_level(10).total_xp_required
            end     
            set_rank level: 12, to: User do |user|
                user.points >= LevelXp.find_by_level(11).total_xp_required
            end
            set_rank level: 13, to: User do |user|
                user.points >= LevelXp.find_by_level(12).total_xp_required
            end          
            set_rank level: 14, to: User do |user|
                user.points >= LevelXp.find_by_level(13).total_xp_required
            end    
            set_rank level: 15, to: User do |user|
                user.points >= LevelXp.find_by_level(14).total_xp_required
            end     
            set_rank level: 16, to: User do |user|
                user.points >= LevelXp.find_by_level(15).total_xp_required
            end    
            set_rank level: 17, to: User do |user|
                user.points >= LevelXp.find_by_level(16).total_xp_required
            end
            set_rank level: 18, to: User do |user|
                user.points >= LevelXp.find_by_level(17).total_xp_required
            end          
            set_rank level: 19, to: User do |user|
                user.points >= LevelXp.find_by_level(18).total_xp_required
            end    
            set_rank level: 20, to: User do |user|
                user.points >= LevelXp.find_by_level(19).total_xp_required
            end     
            set_rank level: 21, to: User do |user|
                user.points >= LevelXp.find_by_level(20).total_xp_required
            end     
            set_rank level: 22, to: User do |user|
                user.points >= LevelXp.find_by_level(21).total_xp_required
            end     
            set_rank level: 23, to: User do |user|
                user.points >= LevelXp.find_by_level(22).total_xp_required
            end    
            set_rank level: 24, to: User do |user|
                user.points >= LevelXp.find_by_level(23).total_xp_required
            end     
            set_rank level: 25, to: User do |user|
                user.points >= LevelXp.find_by_level(24).total_xp_required
            end     
            set_rank level: 26, to: User do |user|
                user.points >= LevelXp.find_by_level(25).total_xp_required
            end     
            set_rank level: 27, to: User do |user|
                user.points >= LevelXp.find_by_level(26).total_xp_required
            end               
            set_rank level: 28, to: User do |user|
                user.points >= LevelXp.find_by_level(27).total_xp_required
            end     
            set_rank level: 29, to: User do |user|
                user.points >= LevelXp.find_by_level(28).total_xp_required
            end     
            set_rank level: 30, to: User do |user|
                user.points >= LevelXp.find_by_level(29).total_xp_required
            end     
            set_rank level: 31, to: User do |user|
                user.points >= LevelXp.find_by_level(30).total_xp_required
            end     
            set_rank level: 32, to: User do |user|
                user.points >= LevelXp.find_by_level(31).total_xp_required
            end     
            set_rank level: 33, to: User do |user|
                user.points >= LevelXp.find_by_level(32).total_xp_required
            end               
            set_rank level: 34, to: User do |user|
                user.points >= LevelXp.find_by_level(33).total_xp_required
            end     
            set_rank level: 35, to: User do |user|
                user.points >= LevelXp.find_by_level(34).total_xp_required
            end     
            set_rank level: 36, to: User do |user|
                user.points >= LevelXp.find_by_level(35).total_xp_required
            end      
            set_rank level: 37, to: User do |user|
                user.points >= LevelXp.find_by_level(36).total_xp_required
            end     
            set_rank level: 38, to: User do |user|
                user.points >= LevelXp.find_by_level(37).total_xp_required
            end     
            set_rank level: 39, to: User do |user|
                user.points >= LevelXp.find_by_level(38).total_xp_required
            end       
            set_rank level: 40, to: User do |user|
                user.points >= LevelXp.find_by_level(39).total_xp_required
            end     
            set_rank level: 41, to: User do |user|
                user.points >= LevelXp.find_by_level(40).total_xp_required
            end          
            set_rank level: 42, to: User do |user|
                user.points >= LevelXp.find_by_level(41).total_xp_required
            end     
            set_rank level: 43, to: User do |user|
                user.points >= LevelXp.find_by_level(42).total_xp_required
            end      
            set_rank level: 44, to: User do |user|
                user.points >= LevelXp.find_by_level(43).total_xp_required
            end          
            set_rank level: 45, to: User do |user|
                user.points >= LevelXp.find_by_level(44).total_xp_required
            end     
            set_rank level: 46, to: User do |user|
                user.points >= LevelXp.find_by_level(45).total_xp_required
            end       
            set_rank level: 47, to: User do |user|
                user.points >= LevelXp.find_by_level(46).total_xp_required
            end     
            set_rank level: 48, to: User do |user|
                user.points >= LevelXp.find_by_level(47).total_xp_required
            end      
            set_rank level: 49, to: User do |user|
                user.points >= LevelXp.find_by_level(48).total_xp_required
            end          
            set_rank level: 50, to: User do |user|
                user.points >= LevelXp.find_by_level(49).total_xp_required
            end     
            set_rank level: 51, to: User do |user|
                user.points >= LevelXp.find_by_level(50).total_xp_required
            end       
            set_rank level: 52, to: User do |user|
                user.points >= LevelXp.find_by_level(51).total_xp_required
            end     
            set_rank level: 53, to: User do |user|
                user.points >= LevelXp.find_by_level(52).total_xp_required
            end       
            set_rank level: 54, to: User do |user|
                user.points >= LevelXp.find_by_level(53).total_xp_required
            end     
            set_rank level: 55, to: User do |user|
                user.points >= LevelXp.find_by_level(54).total_xp_required
            end           
            set_rank level: 56, to: User do |user|
                user.points >= LevelXp.find_by_level(55).total_xp_required
            end       
            set_rank level: 57, to: User do |user|
                user.points >= LevelXp.find_by_level(56).total_xp_required
            end     
            set_rank level: 58, to: User do |user|
                user.points >= LevelXp.find_by_level(57).total_xp_required
            end      
            set_rank level: 59, to: User do |user|
                user.points >= LevelXp.find_by_level(58).total_xp_required
            end       
            set_rank level: 60, to: User do |user|
                user.points >= LevelXp.find_by_level(59).total_xp_required
            end                                                                                                            
        end
    end
end
