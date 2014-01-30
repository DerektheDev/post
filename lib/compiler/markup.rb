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

    def self.apply_head_tag document, *head_stylesheets
      head_tag = if document.xpath("//head").present?
        head_already_existed = true
        document.xpath("//head").first
      else
        Nokogiri::XML::Element.new('head', document)
      end
      
      head_hash = {
        meta:  {
          name: 'viewport',
          content: 'user-scalable=no, width=device-width'
        },
        # title: { tag_content: @campaign.name },
      }

      if head_stylesheets
        head_hash[:style] = {
          type: 'text/css',
          tag_content: (
            head_stylesheets.flatten.map{|ss|
              ss.read
            }.flatten[0].prepend("\n")
          )
        }
      end

      head_hash.each do |tag, attributes|
        node = Nokogiri::XML::Element.new tag.to_s, document
        attributes.each do |k,v|
          if k == :tag_content
            node.content = v
          else
            node[k] = v
          end
        end
        head_tag << node
      end

      unless head_already_existed
        document.children.first.add_previous_sibling(head_tag)
      end

      tree_root_string = document.to_html
      tree_root_string.prepend "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd\">\n"
      document = Nokogiri::HTML(tree_root_string)
    end

    def self.render markup_file, inline_stylesheets, *head_stylesheets

      tree = self.build_tree markup_file
      
      # @tree_root = tree.root.children.first # skips straight to inside body tag
      @tree_root = tree.root

      # inline the stylesheets specified as such,
      # in the order in which they are passed
      inline_stylesheets.each do |ss|
        css_tree = Compiler::Styles.build_tree ss
        self.apply_inline_styles @tree_root, @tree_root, css_tree
      end

      @tree_root[:xmlns] = "http://www.w3.org/1999/xhtml"

      self.apply_head_tag @tree_root, head_stylesheets

      output_markup = @tree_root
    end

    def self.apply_inline_styles tree, branch, css_tree

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
            self.apply_inline_styles tree, node, css_tree
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
