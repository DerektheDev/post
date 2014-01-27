class CampaignsController < ApplicationController

  before_filter :get_campaign, only: [:show, :destroy, :collect_resources, :select_resource, :get_markups, :get_compiled_html]

  def index
    @campaigns   ||= Campaign.order(:created_at).reverse_order
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

  def select_resource
    session[:sel_mu_id] = params[:selected_markup] if params[:selected_markup]
    collect_resources
    respond_to do |format|
      format.js
    end
  end

private

  def get_campaign
    campaign_id ||= params[:id] || session[:campaign_id]
    @campaign ||= Campaign.find(campaign_id)
  end

  def get_markups
    @markup_docs = @campaign.resources.markups
  end

  def collect_resources
    get_markups
    @selected_markup = @markup_docs.find(session[:sel_mu_id])

    get_compiled_html @selected_markup
  end

  def get_compiled_html markup
    markup_file = File.new(markup.file.path)
    if markup.cache_valid? && 1==2
      rendered_html = Nokogiri::HTML(markup.cached_compilation)
    else
      head_stylesheets = @campaign.ordered_stylesheets(File.basename(markup_file), :head).map do |pca|
        File.new("public#{strip_query pca.file.url}") # pca = paperclip attachment
      end
      inline_stylesheets = @campaign.ordered_stylesheets(File.basename(markup_file), :inline).map do |pca|
        File.new("public#{strip_query pca.file.url}")
      end
      rendered_html = Compiler::Markup.render(markup_file, inline_stylesheets, head_stylesheets)


      rendered_html[:xmlns] = "http://www.w3.org/1999/xhtml"

      prepended_head = Nokogiri::XML::Element.new 'head', rendered_html
      
      head_hash = {
        meta:  {
          name: 'viewport',
          content: 'user-scalable=no, width=device-width'
        },
        title: { tag_content: @campaign.name },
        style: {
          type: 'text/css',
          tag_content: "\n\n"
        }
      }

      head_hash.each do |tag, attributes|
        node = Nokogiri::XML::Element.new tag.to_s, rendered_html
        attributes.each do |k,v|
          if k == :tag_content
            node.content = v
          else
            node[k] = v
          end
        end
        prepended_head << node
      end

      rendered_html.children.first.add_previous_sibling(prepended_head)

      rendered_html_string = rendered_html.to_html
      rendered_html_string.prepend "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd\">\n"


      markup.cached_compilation = rendered_html_string

      markup.cache_valid = true
      markup.save
    end
    @rendered_html_app_imgs   = Resource.app_relative_paths(rendered_html.dup, @campaign)
    @shl_rendered_html        = Compiler.syntax_highlight rendered_html_string, :html
  end

  def campaign_params
    params.require(:campaign).permit(:name)
  end
  
end
