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

end
