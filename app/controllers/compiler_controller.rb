class CompilerController < ApplicationController

  def index
    compile_styles("app/assets/stylesheets/test.css")
    compile_markup("app/views/compiler/markup/example.haml")
  end

  def compile_styles doc_path
    input_styles = File.open(doc_path, 'r').read
    rendered_css = case get_ext(doc_path)
    when :css
      tree = CSSPool.CSS(open(doc_path)).to_css
    when :scss
      tree = Sass::Engine.for_file(doc_path, {})
      tree.render
    when :less
      parser = Less::Parser.new
      tree = parser.parse(File.open(doc_path, 'r').read)
      tree.to_css
    end

    @css_doc      = CSSPool.CSS(rendered_css)
    @input_styles = CodeRay.scan(input_styles, get_ext(doc_path)).div(line_numbers: nil).gsub(/\n/, '<br>')
  end

  def compile_markup doc_path

    raw_input_markup_preprocessed = File.open(doc_path, 'r').read

    tree = case get_ext(doc_path)
    when :html
      Nokogiri::HTML(open(doc_path))
    when :haml
      engine = Haml::Engine.new(raw_input_markup_preprocessed)
      # http://haml.info/docs/yardoc/file.REFERENCE.html
      Nokogiri::HTML(engine.render)
    end

    #
    # For media queries, we'll probably have to open the document,
    # quarantine the media queries out of the file (into a separate
    # array), and then place them in the head of the document when
    # finished.
    #

    @dom_output ||= []

    tree_root = tree.root.children.first # skips straight to inside body tag

    @input_markup_preprocessed = CodeRay.scan(raw_input_markup_preprocessed, get_ext(doc_path)).div(line_numbers: nil).gsub(/\n/, '<br>')
    @input_markup_postprocessed = CodeRay.scan(tree_root.to_html, :html).div(line_numbers: nil).gsub(/\n/, '<br>')


    apply_styles tree_root, tree_root


    @output_markup = @dom_output.map(&:to_html).join("\n")

    @output_markup_colored = CodeRay.scan(@output_markup, :html).div(line_numbers: nil).gsub(/\n/, '<br>')
  end

#############################

  def get_ext doc_path
    output = File.extname(doc_path).gsub(/\./,'').to_sym
    output = output == :scss ? :sass : output
  end

  def nodes_found_for branch, selector
    found_nodes = branch.css(selector.to_s).to_a
    found_nodes.uniq{|elem| elem.path}
  end

  def nodes_found_for? branch, selector
    found_nodes = nodes_found_for(branch, selector)
    (found_nodes && found_nodes.count > 0) ? true : false
  end

  def apply_styles tree, branch

    branch.children.each do |node|

      if node.class == Nokogiri::XML::Element

        matching_rule_sets = []
        matching_nodes = []

        @css_doc.rule_sets.each do |rule_set|
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
          apply_styles tree, node.children
        end
      end
    end
  end
end
