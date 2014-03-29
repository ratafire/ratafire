class Tag < ActsAsTaggableOn::Tag

 #--- User ---
 #has_many :reverse_followed_tags, foreign_key: "user_id", class_name: "TagRelationship", dependent: :destroy
 #has_many :users, through: :reverse_followed_tags, source: :tag_follower
 
 #--- Methods --- 
 def self.random(count = 1)
    total_count = self.count
    
    Array.new(count) do |e|
      offset = rand(total_count)
      Tag.first(:offset => offset)
    end
  end
  
  def self.autocomplete(q)
    q = "%#{q}%"
    where("tags.name LIKE ?", q).order('name ASC').limit(5)
  end
  
  def self.autocomplete_data(q)
    Tag.autocomplete(q).map(&:name)
  end
  
end