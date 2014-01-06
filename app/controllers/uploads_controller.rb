class UploadsController < ApplicationController
  def create
    file = params[:upload]
    extension = Compiler.get_ext(file.original_filename)
    campaign = Campaign.find(session[:campaign_id])

    if extension == :zip
      # unzip zip file
      # require 'zip'
      # temp_file = Zip::ZipFile.new("tmp/uploaded_assets/#{campaign.id}_#{Time.now.to_i}")
      # temp_file.write(file.read)
      # temp_file.close
      # Zip::File.open(temp_file.path) do |zipfiles|
      #   zipfiles.each do |file|
      #     zfext = Compiler.get_ext file
      #     sort_and_create_files_for zfext, campaign
      #   end
      # end
      # ap temp_file
    else
      sort_and_create_files_for extension, campaign
    end

    redirect_to campaign_path(session[:campaign_id])
  end

private
  # Use strong_parameters for attribute whitelisting
  # Be sure to update your create() and update() controller methods.

  def user_params
    params.require(:upload).permit(:file)
  end

  def sort_and_create_files_for extension, campaign

    asset_type = Resource.get_resource_type extension

    if Resource.permitted_filetypes.include? extension
      @resource = Resource.create({
        campaign_id: session[:campaign_id],
          extension: extension
      })
      if Resource.permitted_image_filetypes.include? extension
        @resource.image = params[:upload]
      else
        @resource.file = params[:upload]
      end
      @resource.save
    else
      flash[:alert] = "Sorry, #{extension} is not a valid filetype"
    end
  end

end
