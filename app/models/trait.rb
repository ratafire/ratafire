class Trait < ActiveRecord::Base

#1 	Concept Artist 概念画家
#2 	Gamer 游戏玩家
#3 	Artistic 文艺
#4 	Computer Whiz 电脑高手
#5 	Musician 音乐家
#6 	Avant Garde 创新者
#7 	Bookworm 爱书人
#8 	Knowledgeable 身经百战
#9 	Ambitious 雄心壮志
#10 Composer 作曲家
#11 Workaholic 工作狂
#12 Researcher 研究员
#13 Geek 极客
#14 Poet 诗人
#15 Writer 作家
#16 Athletic 运动健将
#17 Outdoorsy 爱好户外
#18 Indoorsy 宅
#19 Vegetarian 素食者
#20 Eco Friendly 环保分子
#21 Spiritual 精神化
#22 Traditionalist 传统的人
#23 Foodie 吃货
#24 Animal Lover 爱动物
#25 Resolute 坚定
#26 Skeptic 怀疑者
#27 Gym-goer 爱好健身
#28 Pianist 钢琴家
#29 Conversationalist 谈判家
#30 Perfectionist 完美主义

    #----------------Relationships----------------

    belongs_to :user
    has_many :inverse_trait_relationships,
        :class_name => 'TraitRelationship'
    has_many :inverse_traits,
    	:through => :inverse_trait_relationships

private

    def generate_uuid!
        begin
            self.uuid = SecureRandom.hex(16)
        end while Trait.find_by_uuid(self.uuid).present?
    end

end
