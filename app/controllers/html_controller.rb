class HtmlController < CompilerController

  def index
    src_html_path = "app/views/html/example_email.html"
    src_html_file = File.open(src_html_path, 'r').read
    @input_html   = CodeRay.scan(src_html_file, :html).div(line_numbers: nil).gsub(/\n/, '<br>')

    src_css_path  = "app/assets/stylesheets/test.css"
    src_css_file  = File.open(src_css_path, 'r').read
    @input_css    = CodeRay.scan(src_css_file, :css).div(line_numbers: nil).gsub(/\n/, '<br>')

    html_doc  = Nokogiri::HTML open(src_html_path)
    css_doc   = CSSPool.CSS open(src_css_path)

    output_array = []
    css_doc.rule_sets.each do |rule_set|
      rule_set.selectors.each do |selector|
        # find elements matching this selector
        elements = html_doc.css(selector.to_s)
        output_array = []
        if elements
          elements.each do |elem|
            attrs = elem.attributes
            if attrs.is_a?(Hash)
              # gather any styles that may already exist
              # on the element so they are not overwritten
              if attrs.has_key?(:style)
                elem[:style] = (elem[:style] + selector.declarations.join(''))
              else
                elem[:style] = selector.declarations.join('')
              end
            end

            output_array.each do |pocket, index|
              if pocket.has_key?(:path) && pocket[:path] == elem[:path]
                output_array.push {path: elem.path, html: elem.to_html}
              else
                output_array[:path] = output_array[:path] + elem.to_html}
              end
            end
            # else
            #   output_array.push {path: elem.path, html: elem.to_html}
            # end
          end
        else
          # No matches
        end
      end
    end
    @output_html = output_array.join("\n")
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
