class ArtworksController < ApplicationController

SEND_FILE_METHOD = :default

protect_from_forgery :except => [:create_project_artwork, :create_majorpost_artwork]

#Temporary download method for I cannot get download to work!!
def show
	@artwork = Artwork.find(params[:id])
	send_file @artwork.image.path,
	:type => @artwork.image.content_type,
	:disposition => 'attachment'
end

def create
  @artwork = Artwork.create(params[:artwork])
#  render json: {:success => true, :artwork_id => @artwork.id}
	#Content temp, this is to save the current content the user is editing...
	if @artwork.majorpost_id != nil then # it is a majorpost
		if @artwork.content_temp != nil && @artwork.content_temp != "" then
			@majorpost = Majorpost.find(@artwork.majorpost_id)
			@majorpost.content = @artwork.content_temp
			if @artwork.tags_temp != nil && @artwork.tags_temp != "" then
				tags = @artwork.tags_temp.split(",")
				@majorpost.tag_list = tags
			end
			@majorpost.save
		end
	else
		if @artwork.content_temp != nil && @artwork.content_temp != "" then
			@project = Project.find(@artwork.project_id)
			@project.about = @artwork.content_temp
			if @artwork.tags_temp != nil && @artwork.tags_tmep != "" then
				tags = @artwork.tags_temp.split(",")
				@project.tag_list = tags
			end
			@project.save
		end	
	end
	#Clean up the temp
	@artwork.content_temp = nil
	@artwork.tags_temp = nil
	@artwork.save
end

def create_project_artwork
	#Create project artwork
	@artwork = Artwork.new(params[:artwork])
	@artwork.user_id = params[:user_id]
	project = Project.find_by_slug(params[:project_id])
	@artwork.project_id = project.id
	@artwork.save
	project.artwork_id = @artwork.id
	project.save
end

def create_majorpost_artwork
	#Create majorpost artwork
	@artwork = Artwork.new(params[:artwork])
	@artwork.user_id = params[:user_id]
	project = Project.find_by_slug(params[:project_id])
	majorpost = Majorpost.find_by_slug(params[:majorpost_id])
	@artwork.project_id = project.id
	@artwork.majorpost_id = majorpost.id
	@artwork.save
	majorpost.artwork_id = @artwork.id
	majorpost.save
end

def download
	@artwork = Artwork.find(params[:id])
	#If not S3
	#send_file @artwork.image.path,
	#:type => @artwork.image.content_type,
	#:disposition => 'attachment', :x_sendfile => true
	#If S3
	data = open(@artwork.image.url)
  	send_data data.read, :type => data.content_type, :x_sendfile => true
end

def destroy
	@artwork = Artwork.find(params[:id])
	#if artwork belongs to majorpost
	if @artwork.majorpost != nil
		@majorpost = @artwork.majorpost
		@majorpost.artwork_id = nil
		@majorpost.save
	else #artwork belongs to project
		@project = @artwork.project
		@project.artwork_id = nil
		@project.save
	end
	@artwork.destroy
	flash[:success] = "Artwork deleted."
	redirect_to(:back)
end

end