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

  def select
    session[:sel_mu_id] = params[:selected_markup] if params[:selected_markup]
    collect @campaign.id
    respond_to do |format|
      format.js
    end
  end

  def collect
    campaign = Campaign.find(params[:cid])
    @stylesheets = campaign.resources.stylesheets
    @markup_docs = campaign.resources.markups
    @images      = campaign.resources.images

    @selected_stylesheet = @stylesheets.find(session[:sel_ss_id])
    @selected_markup     = @markup_docs.find(session[:sel_mu_id])

    get_styles File.new @selected_stylesheet.file.path
    get_markup File.new(@selected_markup.file.path), File.new(@selected_stylesheet.file.path)
  end

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
    rendered_html             = Compiler::Markup.render markup_file, styles_file
    @rendered_html_app_imgs   = Resource.app_relative_paths(rendered_html.dup, @campaign)
    @shl_rendered_html        = Compiler.syntax_highlight rendered_html, :html
  end

end
