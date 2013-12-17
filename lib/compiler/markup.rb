module Compiler
  module Markup
    def self.render markup_file, styles_file

      tree = case Compiler.get_ext(markup_file)
      when :html
        Nokogiri::HTML(markup_file.read)
      when :haml
        engine = Haml::Engine.new(markup_file.read)
        # http://haml.info/docs/yardoc/file.REFERENCE.html
        Nokogiri::HTML(engine.render)
      end

      #
      # For media queries, we'll probably have to open the document,
      # quarantine the media queries out of the file (into a separate
      # array), and then place them in the head of the document when
      # finished.
      #


      tree_root = tree.root.children.first # skips straight to inside body tag

      @input_markup_preprocessed = CodeRay.scan(markup_file.read, Compiler.get_ext(markup_file)).div(line_numbers: nil).gsub(/\n/, '<br>')
      @input_markup_postprocessed = CodeRay.scan(tree_root.to_html, :html).div(line_numbers: nil).gsub(/\n/, '<br>')


      @dom_output ||= []
      @dom_output = self.apply_styles tree_root, tree_root, styles_file


      @output_markup = @dom_output.map(&:to_html).join("\n")

      @output_markup_colored = CodeRay.scan(@output_markup, :html).div(line_numbers: nil).gsub(/\n/, '<br>')
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
              found_nodes = nodes_found_for(tree, selector)

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
          if matching_rule_sets.present?
            styles_for_rs = matching_rule_sets.uniq{|dec| dec}.map{|rs| rs.declarations}.join('').strip
          end

          if matched_index = @dom_output.index{|elem| elem.path == node.path}
            current_styles = @dom_output[matched_index][:style]
            @dom_output[matched_index][:style] = (current_styles + styles_for_rs).strip
          elsif styles_for_rs
            node[:style] = styles_for_rs
            @dom_output.push node
          end

          unless node.children.empty?
            apply_styles tree, node.children, styles_file
          end
        end
      end
    end
  end
end
