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

    dom_output ||= []

#     @css_doc.rule_sets.each do |rule_set|
#       rule_set.selectors.each do |selector|
# =begin
#   FAILING_EXAMPLE.HAML FAILS HERE
#   NO MATCHES
# =end
#         # find elements matching this selector
#         matched_elems = tree.css(selector.to_s)
#         ap matched_elems
#         if matched_elems
#           matched_elems.each do |node|
#             # create an array of found elements
#             # If we already have an element in this array that has the same
#             # node path, simply add to its style string. This will prevent
#             # styles from being overwritten by the new style declaration block.
#             if index_match = dom_output.index{|pocket| pocket[:node].path == node.path}
#               dom_output[index_match][:css].push selector.declarations
#               dom_output[index_match][:node][:style] = dom_output[index_match][:css].join('').strip
#             else
#               # but if this is a new DOM element that has not yet been styled
#               # then we can push it into the array as such
#               node[:style] = selector.declarations.join('').strip
#               dom_output.push({ node: node, css: selector.declarations })
#             end
#           end
#         end
#       end
#     end


    tree.root.children.each do |node|
      matching_rule_sets = []
      node[:style] = []
      @css_doc.rule_sets.each do |rule_set|
        rule_set.selectors.each do |selector|
          # selector.to_s # tagname.classname
          if tree.css(selector.to_s).include? node
            node[:style].push rule_set.declarations
          end
        end
      end

# oops

      dom_output.push node
    end

# laksdjfksajdf


    @output_markup = dom_output.map(&:to_html).join("\n")
    @output_markup_colored = CodeRay.scan(@output_markup, :html).div(line_numbers: nil).gsub(/\n/, '<br>')
  end

#############################

  def get_ext doc_path
    output = File.extname(doc_path).gsub(/\./,'').to_sym
    output = output == :scss ? :sass : output
  end

end
