class MajorpostSuggestion < ActiveRecord::Base
  attr_accessible :popularity, :term

   def self.terms_for(prefix)
  	suggestions = where("term like ?", "#{prefix}_%")
  	suggestions.order("popularity desc").limit(10).pluck(:term)
  end

  def self.index_majorposts
  	Majorpost.find_each do |majorpost|
  		index_term(majorpost.title)
  		majorpost.title.split.each { |t| index_term(t) }
  	end
  end

  def self.index_term(term)
  	where(term: term.downcase).first_or_initialize.tap do |suggestion|
  		suggestion.increment! :popularity
  	end
  end 
end
