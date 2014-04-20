namespace :project_suggestions do
  desc "Generate suggestions for projects"
  task :index => :environment do
    ProjectSuggestion.index_project
  end
end