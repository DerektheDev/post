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

    output_array ||= []
    css_doc.rule_sets.each do |rule_set|
      rule_set.selectors.each do |selector|
        # find elements matching this selector
        elements = html_doc.css(selector.to_s)
        if elements
          elements.each do |elem|
            attrs = elem.attributes
            if attrs.is_a?(Hash) && attrs.has_key?(:style)
              output_array.each do |pocket, index|
                # ap pocket[:path]
                # ap elem[:path]
                if pocket[:path] == elem.path
                  elem[:style] = pocket[:declarations] + selector.declarations.join('')
                  output_array.push({
                            path: elem.path,
                            html: elem.to_html,
                    declarations: elem[:style]
                  })
                end
              end
            else
              elem[:style] = selector.declarations.join('')
              output_array.push({
                        path: elem.path,
                        html: elem.to_html,
                declarations: elem[:style]
              })
            end            
          end
        else
          # No matches
        end
      end
    end

=begin
  What if instead, I push these all into an array, no looping or anything,
  and then when the loop is done, I can merge all items with the same path.
=end

    @output_html = output_array.map{|pocket| pocket[:html]}.join("\n")
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
