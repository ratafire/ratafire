namespace :majorpost_suggestions do
  desc "Generate suggestions for majorposts"
  task :index => :environment do
    MajorpostSuggestion.index_majorposts
  end
end