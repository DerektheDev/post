class CompilerController < ApplicationController

  def index
    styles_file               = File.new("app/assets/stylesheets/test.css")
    markup_file               = File.new("app/views/compiler/markup/example.html")

    # styles
    @input_styles_raw         = styles_file.read
    @shl_input_styles_raw     = Compiler.syntax_highlight styles_file, Compiler.get_ext(styles_file)
    @shl_input_styles_to_css  = Compiler.syntax_highlight(Compiler::Styles.build_tree(styles_file).to_css, :css)
    @rendered_css             = Compiler::Styles.render   styles_file
    @shl_rendered_css         = Compiler.syntax_highlight @rendered_css, :css


    # markup
    @input_markup_raw         = markup_file.read
    @shl_input_markup_raw     = Compiler.syntax_highlight markup_file, Compiler.get_ext(markup_file)
    @shl_input_markup_to_html = Compiler.syntax_highlight(Compiler::Markup.build_tree(markup_file).to_html, :html)
    @rendered_html            = Compiler::Markup.render   markup_file, styles_file
    @shl_rendered_html        = Compiler.syntax_highlight @rendered_html, :html
  end
  
end
