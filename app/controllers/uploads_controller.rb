class UploadsController < ApplicationController
  def create
    # ap 'starting create'

    og_fname = params[:upload].original_filename
    extension = Compiler.get_ext(og_fname)

    session[:campaign_id] = session[:campaign_id] || Campaign.create

    if extension == :zip
      # unzip zip file
      # each file/sort/create
    else
      sort_and_create_files_for campaign
    end
    redirect_to root_path
  end

private
  # Use strong_parameters for attribute whitelisting
  # Be sure to update your create() and update() controller methods.

  def user_params
    params.require(:upload).permit(:file)
  end

  def sort_and_create_files_for campaign
    if Markup.permitted_filetypes.include? extension
      # upload as markup document
      @markup = Markup.create({
         campaign_id: session[:campaign_id],
                file: params[:upload],
        preprocessed: params[:upload].read
      })
    elsif Stylesheet.permitted_filetypes.include? extension
      # upload as a stylesheet document
      @stylesheet = Stylesheet.create({
         campaign_id: session[:campaign_id],
                file: params[:upload],
        preprocessed: params[:upload].read
      })
    elsif Image.permitted_filetypes.include? extension
      # upload as an image
      @image = Image.create({
        campaign_id: session[:campaign_id],
               file: params[:upload]
      })
    else
      flash[:alert] = "Sorry, #{extension} is not a valid filetype"
    end
  end

end
