class UploadsController < ApplicationController
  def create

    og_fname = params[:upload][:file].original_filename
    extension = Compiler.get_ext(og_fname)

    if extension == :zip
      # do something with the uploaded zip file
      
    elsif Markup.permitted_filetypes.include? extension
      # upload as markup document
      @markup = Markup.create({
                file: params[:upload][:file],
        preprocessed: params[:upload][:file].read
      })
    elsif Stylesheet.permitted_filetypes.include? extension
      # upload as a stylesheet document
      @stylesheet = Stylesheet.create({
                file: params[:upload][:file],
        preprocessed: params[:upload][:file].read
      })
    else
      flash[:alert] = "Sorry, #{extension} is not a valid filetype"
    end
    redirect_to root_path
  end

private
  # Use strong_parameters for attribute whitelisting
  # Be sure to update your create() and update() controller methods.

  def user_params
    params.require(:upload).permit(:file)
  end

end