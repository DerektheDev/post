module Compiler
  module Styles

    def self.build_tree file
      tree_string = self.render file
      CSSPool.CSS(tree_string)
    end

    def collect_at_rules file
      style_doc = File.read file

      # scan document for block (while loop?)
      style_doc.scan(/^@(.*){\n(.*)/)

      # when a block is found, find the end of it

      # read block into string...

      # ...and pass the string value into an array

      # finally, this array should be stringified into
      # a head style tag in the compiled document
    end

    def self.render file

      # file_wo_mqs = self.collect_media_queries file

      tree_string = case Compiler.get_ext(file)
      when :css
        CSSPool.CSS(File.read file).to_css
      when :scss
        tree = Sass::Engine.for_file(File.read file, {})
        tree.render
      when :less
        parser = Less::Parser.new
        tree = parser.parse(File.read file)
        tree.to_css
      end
      tree_string
    end
  end
end
