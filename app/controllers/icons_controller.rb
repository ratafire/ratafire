class IconsController < ApplicationController

SEND_FILE_METHOD = :default

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