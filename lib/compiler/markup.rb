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

    def self.render markup_file, inline_stylesheets, *head_stylesheets

      tree = self.build_tree markup_file
      
      # @tree_root = tree.root.children.first # skips straight to inside body tag
      @tree_root = tree.root

      # apply the styles for each stylesheet, in the
      # order in which they are passed
      inline_stylesheets.each do |ss|
        css_tree = Compiler::Styles.build_tree ss
        self.apply_styles @tree_root, @tree_root, css_tree
      end

      output_markup = @tree_root
    end

    def self.apply_styles tree, branch, css_tree

      branch.children.each do |node|
        if node.class == Nokogiri::XML::Element
          matching_rule_sets = []

          css_tree.rule_sets.each do |rule_set|
            rule_set.selectors.each do |selector|
              # find nodes that match the selector
              found_nodes = self.nodes_found_for(tree, selector)

              # if this rule_set applies to this node
              matching_nodes = found_nodes.select{|fn| fn.path == node.path}

              if matching_nodes.present?
                matching_rule_sets.push({
                  rule_set: rule_set,
                  specificity: selector.specificity.zip([100, 10, 1]).map{|x,y| x*y}.inject(:+)
                })
              end
            end
          end

          # if there are any rule_sets that apply to this node, inline 'em
          if matching_rule_sets.present?
            new_styles = matching_rule_sets.sort_by{ |rs|
              rs[:specificity]
            }.map{|rs|
              rs[:rule_set].declarations.map{ |dec|
                dec.to_css
              }
            }.flatten.join('').strip

            # apply the styles
            if matched_node = @tree_root.xpath(node.path).first

              matched_node[:style] = if matched_node.has_attribute? 'style'
                # if the document already contains a style string,
                # don't throw it away!
                [matched_node[:style], new_styles].join('')
              else
                new_styles
              end
            end
          end

          # move down the Nokogiri DOM tree
          unless node.children.empty?
            apply_styles tree, node, css_tree
          end
        end
      end
    end

    def self.nodes_found_for branch, selector
      if found_nodes = branch.css(selector.to_s).to_a
        o = found_nodes.uniq{|elem| elem.path}
      else
        o = nil
      end
      o
    end

    def self.nodes_found_for? branch, selector
      found_nodes = nodes_found_for(branch, selector)
      (found_nodes && found_nodes.count > 0) ? true : false
    end
  end
end
