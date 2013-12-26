class CompilerController < ApplicationController

  def index
    # session[:campaign_id] = if session[:campaign_id] && Campaign.exists?(session[:campaign_id])
    #   session[:campaign_id]
    # else
    #   Campaign.create.id
    # end
    # @campaign = Campaign.find(session[:campaign_id])
    @campaign = Campaign.first

    collect_assets_for @campaign
  end

private
  def collect_assets_for campaign
    stylesheets = @campaign.stylesheets
    markup_docs = @campaign.markups
    images      = @campaign.images

    get_styles stylesheets.first
    get_markup markup_docs.first, stylesheets.first
  end

  def get_styles styles_file
    @input_styles_raw         = styles_file.read
    @shl_input_styles_raw     = Compiler.syntax_highlight styles_file, Compiler.get_ext(styles_file)
    @shl_input_styles_to_css  = Compiler.syntax_highlight(Compiler::Styles.build_tree(styles_file).to_css, :css)
    @rendered_css             = Compiler::Styles.render   styles_file
    @shl_rendered_css         = Compiler.syntax_highlight @rendered_css, :css
  end

  def get_markup markup_file, styles_file
    @input_markup_raw         = markup_file.read
    @shl_input_markup_raw     = Compiler.syntax_highlight markup_file, Compiler.get_ext(markup_file)
    @shl_input_markup_to_html = Compiler.syntax_highlight(Compiler::Markup.build_tree(markup_file).to_html, :html)
    @rendered_html            = Compiler::Markup.render   markup_file, styles_file
    @shl_rendered_html        = Compiler.syntax_highlight @rendered_html, :html
  end
  
end
