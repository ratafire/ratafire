namespace :user_suggestions do
  desc "Generate suggestions for users"
  task :index => :environment do
    UserSuggestion.index_user
  end
end