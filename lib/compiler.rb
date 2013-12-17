module Compiler
  
  def self.get_ext file
    output = File.extname(doc_path).gsub(/\./,'').to_sym
    output = output == :scss ? :sass : output
  end

  def self.render_css file
    tree_string = case self.get_ext(doc_path)
    when :css
      CSSPool.CSS(open(doc_path)).to_css
    when :scss
      tree = Sass::Engine.for_file(doc_path, {})
      tree.render
    when :less
      parser = Less::Parser.new
      tree = parser.parse(File.read(doc_path))
      tree.to_css
    end
    CSSPool.CSS(rendered_css)
  end

  def self.syntax_highlight file
    CodeRay.scan(file, self.get_ext(doc_path)).div(line_numbers: nil).gsub(/\n/, '<br>')
  end

end
