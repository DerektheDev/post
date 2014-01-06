class CampaignsController < ApplicationController
  def index
    @campaigns = Campaign.all
    @campaign  = @campaigns.first
    session[:campaign_id] ||= @campaign.id
    session[:sel_mu_id]   ||= @campaign.resources.markups.first.id
    session[:sel_ss_id]   ||= @campaign.resources.stylesheets.first.id
  end

  def show
    @campaign = Campaign.first
  end

  def preview
    @campaign = Campaign.find(params[:id])

    markup_file = @campaign.resources.markups.first
    styles_file = @campaign.resources.stylesheets.first

    rendered_html             = Compiler::Markup.render markup_file, styles_file
    @rendered_html_app_imgs   = Resource.app_relative_paths(rendered_html.dup, @campaign)

    respond_to do |format|
      format.js
    end
  end

  def new

  end

  def create

  end

  def edit

  end

  def update

  end

  def delete

  end

  def destroy

  end
  
end
