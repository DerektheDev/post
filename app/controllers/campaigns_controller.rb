class CampaignsController < ApplicationController
  def index
    @campaigns = Campaign.all
  end

  def show
    @campaign = Campaign.first
    session[:campaign_id] ||= @campaign.id
    session[:sel_mu_id]   ||= Asset.markups.first.id
    session[:sel_ss_id]   ||= Asset.stylesheets.first.id
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
