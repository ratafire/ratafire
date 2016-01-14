class Github < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :user

  def self.find_for_github_oauth(auth, user_id)
  	where(auth.slice(:uid)).first_or_create do |github|
  		github.uid = auth.uid
  		github.name = auth.info.name
  		github.image = auth.info.image
  		github.link = auth.info.urls.GitHub
  		github.username = auth.extra.raw_info.login
  		github.email = auth.info.email
  		github.oauth_token = auth.credentials.token
  		github.hireable = auth.extra.raw_info.hireable
  		github.public_repos = auth.extra.raw_info.public_repos
  		github.user_id = user_id
  		github.save
  	end
  end

end
