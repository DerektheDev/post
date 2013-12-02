class HtmlController < CompilerController

  def index
    src_html_path = "app/views/html/example_email.html"
    html_doc      = Nokogiri::HTML open(src_html_path)
    @input_html   = CodeRay.scan(html_doc, :html).div(line_numbers: nil).gsub(/\n/, '<br>')

    src_css_path  = "app/assets/stylesheets/test.css"
    css_doc       = CSSPool.CSS(open(src_css_path))
    @input_css    = CodeRay.scan(css_doc, :css).div(line_numbers: nil).gsub(/\n/, '<br>')

    dom_output ||= []

    css_doc.rule_sets.each do |rule_set|
      rule_set.selectors.each do |selector|
        # find elements matching this selector
        matched_elems = html_doc.css(selector.to_s)
        if matched_elems
          matched_elems.each do |node|
            # create an array of found elements
            # If we already have an element in this array that has the same
            # node path, simply add to its style string. This will prevent
            # styles from being overwritten by the new style declaration block.
            if index_match = dom_output.index{|pocket| pocket[:node].path == node.path}
              dom_output[index_match][:css].push selector.declarations
              dom_output[index_match][:node][:style] = dom_output[index_match][:css].join('').strip
            else
              # but if this is a new DOM element that has not yet been styled
              # then we can push it into the array as such
              dom_output.push({ node: node, css: selector.declarations })
            end
          end
        end
      end
    end

    @output_html = dom_output.map{|pocket| pocket[:node].to_html}.join("\n")
    @output_html_colored = CodeRay.scan(@output_html, :html).div(line_numbers: nil).gsub(/\n/, '<br>')
  end

  def compile
    # grab the uploaded file
    # file = retrieve_source

    # fetch stylesheets (style tags, both in-doc and external
    # in the order they are declared
    # find_style_declarations

    # compress them into one block of text


    # take each declared block of the CSS,
    # search the DOM for where the rule would target

    # apply the styles inline

    # start building a JSON object which will output as HTML

    # properly indent it all
  end

  def retrieve_source
  end

end
