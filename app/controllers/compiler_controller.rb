class CompilerController < ApplicationController

  def index
    # session[:campaign_id] = if session[:campaign_id] && Campaign.exists?(session[:campaign_id])
    #   session[:campaign_id]
    # else
    #   Campaign.create.id
    # end
    # @campaign = Campaign.find(session[:campaign_id])

    collect_assets
  end

  def collect_assets
    @campaign = Campaign.first
    session[:campaign_id] ||= @campaign.id

    stylesheets = @campaign.stylesheets
    markup_docs = @campaign.markups
    images      = @campaign.images

    get_styles File.new stylesheets.first.file.path
    get_markup File.new(markup_docs.first.file.path), File.new(stylesheets.first.file.path)
  end

  def review_code
    file = File.new("public#{params[:file]}")
    @sh_code = Compiler.syntax_highlight(file, Compiler.get_ext(file))
  end

  def select_assets

  end

  def delete_asset
    
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
