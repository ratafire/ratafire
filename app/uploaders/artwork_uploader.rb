# encoding: utf-8

class ArtworkUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  after :store, :delete_old_tmp_file
  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_white_list
    %w(jpg jpeg gif png iff riff tiff xbm jp2 psd bmp)
  end

  version :preview do
    process :resize_to_limit => [790,0]
  end

  def cache!(new_file)
    super
    @old_tmp_file = new_file
  end
  
  def delete_old_tmp_file(dummy)
    @old_tmp_file.try :delete
  end

end
