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

    input_markup = File.open(doc_path, 'r').read

    tree = case get_ext(doc_path)
    when :html
      Nokogiri::HTML(open(doc_path))
    when :haml
      engine = Haml::Engine.new(input_markup)
      # http://haml.info/docs/yardoc/file.REFERENCE.html
      Nokogiri::HTML(engine.render)
    end

    #
    # For media queries, we'll probably have to open the document,
    # quarantine the media queries out of the file (into a separate
    # array), and then place them in the head of the document when
    # finished.
    #

    @input_markup = CodeRay.scan(input_markup, get_ext(doc_path)).div(line_numbers: nil).gsub(/\n/, '<br>')

    @dom_output ||= []

    tree_root = tree.root.children.first # skips straight to inside body tag

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

    branch.children.select{|node| node.class == Nokogiri::XML::Element}.each do |node|
      matching_rule_sets = []

      @css_doc.rule_sets.each do |rule_set|
        rule_set.selectors.each do |selector|
          # find nodes that match the selector
          found_nodes = nodes_found_for(tree, selector)
          # if this rule_set applies to this node
          matching_nodes = found_nodes.select{|fn| fn.path == node.path}
          if matching_nodes.present?
            matching_rule_sets.push rule_set
          end
        end
      end

      # if there are any rule_sets that apply to this node, inline 'em
      if matching_rule_sets.present?
        styles_for_rs = matching_rule_sets.map{|rs| rs.declarations}.join('').strip
      end

      if matched_index = @dom_output.index{|elem| elem.path == node.path}
        @dom_output[matched_index][:style] = @dom_output[matched_index][:style] + styles_for_rs
      elsif styles_for_rs
        node[:style] = styles_for_rs
        @dom_output.push node
      end

      unless branch.children.empty?
        apply_styles tree, branch.children
      end
    end
  end

end
