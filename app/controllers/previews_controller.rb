class PreviewsController < ApplicationController

  def index
    session[:campaign_id] ||= Campaign.first.id
    session[:sel_mu_id]   ||= Asset.markups.first.id
    session[:sel_ss_id]   ||= Asset.stylesheets.first.id
    collect_assets
  end

  def collect_assets
    @campaign    = Campaign.find(session[:campaign_id])
    @stylesheets = @campaign.assets.stylesheets
    @markup_docs = @campaign.assets.markups
    @images      = @campaign.assets.images

    @selected_stylesheet = @stylesheets.find(session[:sel_ss_id])
    @selected_markup     = @markup_docs.find(session[:sel_mu_id])

    get_styles File.new @selected_stylesheet.file.path
    get_markup File.new(@selected_markup.file.path), File.new(@selected_stylesheet.file.path)
  end

  def review_code
    asset = Asset.find(params[:id])
    file = File.new(strip_query "public#{asset.file.url}")
    @sh_code = Compiler.syntax_highlight(file, Compiler.get_ext(file))
  end

  def select_assets
    session[:sel_mu_id] = params[:selected_markup] if params[:selected_markup]
    session[:sel_ss_id] = params[:selected_stylesheet] if params[:selected_stylesheet]
    collect_assets
  end

  def delete_asset

  end

  def refresh_assets

  end

private

  def get_styles styles_file
    @input_styles_raw         = File.read styles_file
    @shl_input_styles_raw     = Compiler.syntax_highlight @input_styles_raw, Compiler.get_ext(styles_file)
    @shl_input_styles_to_css  = Compiler.syntax_highlight(Compiler::Styles.build_tree(styles_file).to_css, :css)
    @rendered_css             = Compiler::Styles.render   styles_file
    @shl_rendered_css         = Compiler.syntax_highlight @rendered_css, :css
  end

  def get_markup markup_file, styles_file
    @input_markup_raw         = File.read markup_file
    @shl_input_markup_raw     = Compiler.syntax_highlight @input_markup_raw, Compiler.get_ext(markup_file)
    @shl_input_markup_to_html = Compiler.syntax_highlight(Compiler::Markup.build_tree(markup_file).to_html, :html)
    @rendered_html            = Compiler::Markup.render   markup_file, styles_file
    @shl_rendered_html        = Compiler.syntax_highlight @rendered_html, :html
  end
  
end
