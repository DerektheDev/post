class UploadsController < ApplicationController
  def create
    # ap 'starting create'
    extension = Compiler.get_ext(params[:upload].original_filename)
    campaign = Campaign.find(session[:campaign_id])

    if extension == :zip
      # unzip zip file
      # each file/sort/create
    else
      sort_and_create_files_for extension, campaign
    end

    redirect_to collect_assets_compiler_index_path
  end

private
  # Use strong_parameters for attribute whitelisting
  # Be sure to update your create() and update() controller methods.

  def user_params
    params.require(:upload).permit(:file)
  end

  def sort_and_create_files_for extension, campaign

    asset_type = Asset.get_asset_type extension

    if Asset.permitted_filetypes.include? extension
      @asset = Asset.create({
        campaign_id: session[:campaign_id],
          extension: extension
      })
      if Asset.permitted_image_filetypes.include? extension
        @asset[:image] = params[:upload]
      else
        @asset[:file] = params[:upload]
      end
    else
      flash[:alert] = "Sorry, #{extension} is not a valid filetype"
    end
  end

end
