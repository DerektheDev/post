class HtmlController < CompilerController

  def index
    src_html_path = "app/views/html/example_email.html"
    src_html_file = File.open(src_html_path, 'r').read
    @input_html   = CodeRay.scan(src_html_file, :html).div(line_numbers: nil).gsub(/\n/, '<br>')

    src_css_path  = "app/assets/stylesheets/test.css"
    src_css_file  = File.open(src_css_path, 'r').read
    @input_css    = CodeRay.scan(src_html_file, :html).div(line_numbers: nil).gsub(/\n/, '<br>')

    html_doc  = Nokogiri::HTML open(src_html_path)
    css_doc   = CSSPool.CSS open(src_css_path)

    output_array ||= []

    css_doc.rule_sets.each do |rule_set|
      rule_set.selectors.each do |selector|
        # find elements matching this selector
        matched_elems = html_doc.css(selector.to_s)
        if matched_elems
          matched_elems.each do |node|
            # push the found elements into an array
            output_array.push({
                  node: node,
              selector: selector
            })
          end
        end
      end
    end

    output_array.each do |elem|
      # find any duplicate elements by DOM path
      matches = output_array.select{|test| test[:node].path == elem[:node].path}

      # if there are duplicates, collect all their styles into a string
      composite_styles = matches.map{|match| match[:selector].declarations}.join('').strip

      # set the style attribute to this new string
      elem[:node][:style] = composite_styles
    end
    # finally, delete the duplicates
    output_array.uniq!{|elem| elem[:node].path}

    @output_html = output_array.map{|pocket| pocket[:node].to_html}.join("\n")
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
