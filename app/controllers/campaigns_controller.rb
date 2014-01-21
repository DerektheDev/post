class CampaignsController < ApplicationController

  before_filter :get_campaign, only: [:show, :destroy, :collect_resources, :select_resource]

  def get_campaign
    campaign_id = params[:id] || session[:campaign_id]
    @campaign = Campaign.find(campaign_id)
  end

  def index
    @campaigns = Campaign.order(:created_at).reverse_order
  end

  def show
    session[:campaign_id] = params[:id]
  end

  def preview
    collect_resources
    respond_to do |format|
      format.js
    end
  end

  def create
    Campaign.create campaign_params
    redirect_to :back
  end

  def destroy
    @campaign.destroy
    redirect_to :back
  end

  def collect_resources
    # @campaign  ||= Campaign.find(params[:id])
    @stylesheets = @campaign.resources.stylesheets
    @markup_docs = @campaign.resources.markups
    @images      = @campaign.resources.images

    # @selected_stylesheet = @stylesheets.first
    @selected_stylesheet = @stylesheets.first
    @selected_markup     = @markup_docs.find(session[:sel_mu_id])

    # get_styles File.new @selected_stylesheet.file.path
    get_markup File.new(@selected_markup.file.path)
  end

  def select_resource
    session[:sel_mu_id] = params[:selected_markup] if params[:selected_markup]
    collect_resources
    respond_to do |format|
      format.js
    end
  end

  def get_styles styles_file
    @input_styles_raw         = File.read styles_file
    @shl_input_styles_raw     = Compiler.syntax_highlight @input_styles_raw, Compiler.get_ext(styles_file)
    @shl_input_styles_to_css  = Compiler.syntax_highlight(Compiler::Styles.build_tree(styles_file).to_css, :css)
    @rendered_css             = Compiler::Styles.render   styles_file
    @shl_rendered_css         = Compiler.syntax_highlight @rendered_css, :css
  end

  def get_markup markup_file
    @campaign = Campaign.find(session[:campaign_id])

    # head_stylesheets = @campaign.ordered_stylesheets(File.basename(markup_file), :head).map do |pca|
    #   File.new("public#{strip_query pca.file.url}") # pca = paperclip attachment
    # end
    inline_stylesheets = @campaign.ordered_stylesheets(File.basename(markup_file), :inline).map do |pca|
      File.new("public#{strip_query pca.file.url}")
    end

    @input_markup_raw         = File.read markup_file
    @shl_input_markup_raw     = Compiler.syntax_highlight @input_markup_raw, Compiler.get_ext(markup_file)
    @shl_input_markup_to_html = Compiler.syntax_highlight(Compiler::Markup.build_tree(markup_file).to_html, :html)
    rendered_html             = Compiler::Markup.render markup_file, inline_stylesheets
    @rendered_html_app_imgs   = Resource.app_relative_paths(rendered_html.dup, @campaign)
    @shl_rendered_html        = Compiler.syntax_highlight rendered_html, :html
  end


private

  def campaign_params
    params.require(:campaign).permit(:name)
  end
  
end
