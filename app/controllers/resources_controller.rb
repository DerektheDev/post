class ResourcesController < ApplicationController

  def show
    @campaign = Campaign.find(session[:campaign_id])
    resource = Resource.find(params[:id])
    file = File.new(strip_query "public#{resource.file.url}")
    @sh_code = Compiler.syntax_highlight(file, Compiler.get_ext(file))
  end

  def destroy
    resource = Resource.find params[:id]
    extension = Compiler.get_ext(resource.file_file_name)
    
    resource.image, resource.file = nil, nil

    # we may be removing a stylesheet... if so, reset the cache
    if Resource.permitted_stylesheet_filetypes.include? extension
      resource.campaign.reset_cache
    end
    resource.save
    resource.destroy
    redirect_to campaign_path(session[:campaign_id])
  end

  def create
    respond_to do |format|
      # ap params
      # ap params[:upload]
      # ap params[:upload].inspect
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

private

  def sort_and_create_files_for extension, campaign

    asset_type = Resource.get_resource_type extension

    if Resource.permitted_filetypes.include? extension
      @resource = Resource.create({
           campaign: campaign,
          extension: extension
      })
      if Resource.permitted_image_filetypes.include? extension
        @resource.image = params[:upload]
      else
        @resource.file = params[:upload]
      end
      if @resource.save
        if Resource.permitted_stylesheet_filetypes.include? extension
          # this is a new stylesheet... time to rebuild the markup!
          campaign.reset_cache
        end
      end
    else
      flash[:alert] = "Sorry, #{extension} is not a valid filetype"
    end
  end

end
