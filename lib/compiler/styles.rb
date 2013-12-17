module Compiler
  module Styles

    def self.build_tree file
      tree_string = self.render file
      CSSPool.CSS(tree_string)
    end

    def self.render file
      tree_string = case Compiler.get_ext(file)
      when :css
        CSSPool.CSS(file.read).to_css
      when :scss
        tree = Sass::Engine.for_file(file.read, {})
        tree.render
      when :less
        parser = Less::Parser.new
        tree = parser.parse(file.read)
        tree.to_css
      end
      tree_string
    end
  end
end
