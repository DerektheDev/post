class CompilerController < ApplicationController

  def index
    # change to pass in a file... not a document path

    styles_file       = File.new("app/assets/stylesheets/test.css")
    markup_file       = File.new("app/views/compiler/markup/example.html")

    @rendered_css     = Compiler::Styles.render styles_file
    @syntax_highlight = Compiler.syntax_highlight styles_file

    @rendered_html    = Compiler::Markup.render markup_file, styles_file
  end

private

#############################

  def nodes_found_for branch, selector
    found_nodes = branch.css(selector.to_s).to_a
    found_nodes.uniq{|elem| elem.path}
  end

  def nodes_found_for? branch, selector
    found_nodes = nodes_found_for(branch, selector)
    (found_nodes && found_nodes.count > 0) ? true : false
  end

  
end
