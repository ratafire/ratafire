module Wikipedia
  class Page
    def initialize(json)
      require 'json'
      @data = JSON::load(json)
    end
    
    def content
      @data['query']['pages'].values.first['revisions'].first.values.first
    end
    
    def redirect?
      content.match(/\#REDIRECT\s+\[\[(.*?)\]\]/)
    end
    
    def redirect_title
      if matches = redirect?
        matches[1]
      end
    end
    
    def title
      @data['query']['pages'].values.first['title']
    end

    def excerpt
      excerpt = @data['query']['pages'].values.first['revisions'].to_s.split("'''")
      title = excerpt[1]
      sentence = excerpt[2].split(".")[0]
    end
  end

end