# encoding: utf-8

class FileUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    #"uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
     File.join( Rails.root, "app", "assets", "images" )
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  version :main, if: :is_sport? do
    process :resize_to_fill => [1019, 510]
    process :optimize
  end

  version :horizontal, if: :is_sport? do
    process :resize_to_fill => [800, 533]
    process :optimize
  end

  version :vertical, if: :is_sport? do
    process :resize_to_fill => [533, 800]
    process :optimize
  end

  version :thumb, if: :is_sport? do
    process :resize_to_fit => [270, 170]
    process :optimize
  end

  version :medium , if: :is_sport?do
    process :resize_to_fit => [300, 300]
    process :optimize
  end

  version :flag, if: :is_country? do
    process :resize_to_fit => [105, 30]
    process :optimize
  end 

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_white_list
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end
  protected
  def is_sport?(img)
    img.content_type.include?('image') && model.attachable_type == 'Sport'
  end

  def is_country?(img)
    img.content_type.include?('image') && model.attachable_type == 'Country'
  end
end
