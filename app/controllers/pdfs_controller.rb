class PdfsController < ApplicationController

	SEND_FILE_METHOD = :default

	protect_from_forgery :except => [:create_project_pdf, :create_majorpost_pdf]

def create_project_pdf
	#Create project Audio
	@pdf = Pdf.new(params[:pdf])
	@pdf.user_id = params[:user_id]
	project = Project.find_by_slug(params[:project_id])
	@pdf.project_id = project.id
	@pdf.save
	project.pdf_id = @pdf.id
	project.save
end	

def create_majorpost_pdf
	#Create majorpost artwork
	@pdf = Pdf.new(params[:pdf])
	@pdf.user_id = params[:user_id]
	project = Project.find_by_slug(params[:project_id])
	majorpost = Majorpost.find_by_slug(params[:majorpost_id])
	@pdf.project_id = project.id
	@pdf.majorpost_id = majorpost.id
	@pdf.save
	majorpost.pdf_id = @pdf.id
	majorpost.save
end

def destroy
	@pdf = Pdf.find(params[:id])
	#if Audio belongs to majorpost
	if @pdf.majorpost != nil
		@majorpost = @pdf.majorpost
		@majorpost.pdf_id = nil
		@majorpost.save
	else #Audio belongs to project
		@project = @pdf.project
		@project.pdf_id = nil
		@project.save
	end
	@pdf.destroy
	flash[:success] = "PDF deleted."
	redirect_to(:back)
end

def download
	@pdf = Pdf.find(params[:id])
	#If not S3
	#send_file @artwork.image.path,
	#:type => @artwork.image.content_type,
	#:disposition => 'attachment', :x_sendfile => true
	#If S3
	data = open(@pdf.pdf.url)
  	send_data data.read, :type => data.content_type, :x_sendfile => true, :filename => @pdf.pdf_file_name
end


end