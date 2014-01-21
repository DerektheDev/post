class ResourcesController < ApplicationController

  def show
    @campaign = Campaign.find(session[:campaign_id])
    resource = Resource.find(params[:id])
    file = File.new(strip_query "public#{resource.file.url}")
    @sh_code = Compiler.syntax_highlight(file, Compiler.get_ext(file))
  end

  def destroy
    resource = Resource.find params[:id]
    resource.image, resource.file = nil, nil
    resource.save
    resource.destroy
    redirect_to campaign_path(session[:campaign_id])
  end

  def create
    respond_to do |format|
      ap params
      ap params[:upload]
      ap params[:upload].inspect
      file = params[:upload]
      extension = Compiler.get_ext(file.original_filename)
      campaign  = Campaign.find(session[:campaign_id])

      if extension == :zip
        # unzip zip file
        # require 'zip'
        # temp_file = Zip::ZipFile.new("tmp/uploaded_resources/#{campaign.id}_#{Time.now.to_i}")
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
      format.js
    end
  end

  def calculate_upload_progress
    # numerator   = 
    # denominator = params[:upload_size]
    # percentage  = (numerator/denominator)
    # render nothing: true
    # respond_to do |format|
    #   format.json
    # end
    render nothing: true
  end

private

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
