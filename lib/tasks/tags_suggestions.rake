namespace :tags_suggestions do
  desc "Generate suggestions for tags"
  task :index => :environment do
    TagsSuggestion.index_tags
  end
end