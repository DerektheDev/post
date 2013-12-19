module Compiler
  module Markup
    
    def self.build_tree markup_file
      tree = case Compiler.get_ext(markup_file)
      when :html
        Nokogiri::HTML(File.read(markup_file))
      when :haml
        engine = Haml::Engine.new(File.read(markup_file))
        # http://haml.info/docs/yardoc/file.REFERENCE.html
        Nokogiri::HTML(engine.render)
      end
      tree
    end

    def self.render markup_file, styles_file

      tree = self.build_tree markup_file

      #
      # For media queries, we'll probably have to open the document,
      # quarantine the media queries out of the file (into a separate
      # array), and then place them in the head of the document when
      # finished.
      #

      # each of these targets every other item... what the...?
      # @tree_root = tree.root.children.first # skips straight to inside body tag
      @tree_root = tree.root

      self.apply_styles @tree_root, @tree_root, styles_file

      output_markup = @tree_root
    end


    def self.apply_styles tree, branch, styles_file

      branch.children.each do |node|
        if node.class == Nokogiri::XML::Element
          matching_rule_sets = []
          matching_nodes = []

          css_tree = Compiler::Styles.build_tree(styles_file)
          css_tree.rule_sets.each do |rule_set|
            rule_set.selectors.each do |selector|
              # find nodes that match the selector
              found_nodes = self.nodes_found_for(tree, selector)

              # if this rule_set applies to this node
              matching_nodes = found_nodes.select{|fn| fn.path == node.path}

              if matching_nodes.present?
                unless matching_rule_sets.include? rule_set
                  matching_rule_sets.push rule_set
                end
              end
            end
          end

          # if there are any rule_sets that apply to this node, inline 'em
          styles_for_rs = if matching_rule_sets.present?
            matching_rule_sets.uniq{|dec| dec}.map{|rs| rs.declarations}
          end

          # apply the styles
          if matched_node = @tree_root.xpath(node.path)
            matched_node.attribute(:style, styles_for_rs.join('').strip) if styles_for_rs
          end

          # move down the Nokogiri DOM tree
          unless node.children.empty?
            apply_styles tree, node.children, styles_file
          end
        end
      end
    end

    def self.nodes_found_for branch, selector
      found_nodes = branch.css(selector.to_s).to_a
      found_nodes.uniq{|elem| elem.path}
    end

    def self.nodes_found_for? branch, selector
      found_nodes = nodes_found_for(branch, selector)
      (found_nodes && found_nodes.count > 0) ? true : false
    end
  end
end
