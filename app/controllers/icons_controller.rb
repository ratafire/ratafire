class IconsController < ApplicationController

SEND_FILE_METHOD = :default

protect_from_forgery :except => [:create_project_icon]

def create
	@icon = Icon.create(params[:icon])
	@project = Project.find(@icon.project_id)
	@project.about = @icon.content_temp
	if @icon.tags_temp != nil && @icon.tags_temp != "" then
		tags = @project.tags_temp.split(",")
		@project.tag_list = tags
	end 
	@project.save
	@icon.content_temp = nil
	@icon.tags_temp = nil
	@icon.save
end

def create_project_icon
	@icon = Icon.new(params[:icon])
	@icon.user_id = params[:user_id]
	project = Project.find_by_slug(params[:project_id])
	@icon.project_id = project.id
	@icon.save
	project.icon_id = @icon.id
	project.save
end

def update
	@icon = Icon.find(params[:id])
end

def destroy
	@icon = Icon.find(params[:id])
	if @icon.project != nil
		@project = @icon.project
		@project.icon_id = nil
		@project.save
	end
	@icon.destroy
	flash[:success] = "Icon deleted."
	redirect_to(:back)
end
end