class MajorpostSuggestions
  def initialize(app)
    @app = app
  end
  
  def call(env)
    if env["PATH_INFO"] == "/majorpost_suggestions"
      request = Rack::Request.new(env)
      terms = MajorpostSuggestion.terms_for(request.params["term"])
      [200, {"Content-Type" => "appication/json"}, [terms.to_json]]
    else
      @app.call(env)
    end
  end
end