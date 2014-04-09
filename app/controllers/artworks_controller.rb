class ArtworksController < ApplicationController

SEND_FILE_METHOD = :default

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

def download
	Resque.enqueue(ArtworkDownloadWorker,params[:id])
	respond_to do |format| format.html { render :nothing => true }
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